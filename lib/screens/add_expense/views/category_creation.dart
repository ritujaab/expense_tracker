import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:uuid/uuid.dart';
import '../../../data/data.dart';
import '../blocs/create_category/create_category_bloc.dart';

getCategoryCreation(BuildContext context, expenseType) {

  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      TextEditingController categoryNameController = TextEditingController();
      bool isLoading = false;
      String selectedIcon = '';
      String categoryColour = Colors.white.toString();
      Category category = Category.empty;


      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (cxt, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                else if (state is CreateCategoryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Something went wrong"),
                    ),
                  );
                }
              },
              child: AlertDialog(
                title: const Text(
                  "Create a Category",
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: categoryNameController,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: isExpanded
                                  ? const BorderRadius.vertical(top: Radius.circular(12))
                                  : BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text("Icon:", style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Icon(
                                  iconOptions[selectedIcon],
                                  size: 30,
                                  color: Colors.black87,
                                ),
                                const Spacer(),
                                const Icon(Icons.expand_circle_down),
                              ],
                            ),
                          ),
                        ),
                        isExpanded
                            ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemCount: iconOptions.length,
                              itemBuilder: (context, i) {
                                String iconKey = iconOptions.keys.toList()[i];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: selectedIcon == iconKey
                                          ? CupertinoColors.systemGreen
                                          : Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      iconOptions[iconKey],
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedIcon = iconKey;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                            : Container(),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                  title: const Text(
                                    "Pick a Color",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorPicker(
                                          pickerColor: Colors.white,
                                          onColorChanged: (color) {
                                            setState(() {
                                              categoryColour = color.toString();
                                            });
                                          },
                                          enableAlpha: false,
                                          showLabel: false,
                                          pickerAreaHeightPercent: 0.8,
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              "Confirm",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text("Colour:", style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                        categoryColour.split('(0x')[1].split(')')[0],
                                        radix: 16,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: kToolbarHeight,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                            onPressed: () {
                              setState((){
                                category.categoryId = const Uuid().v1();
                                category.name = categoryNameController.text;
                                category.icon = selectedIcon;
                                category.color = categoryColour;
                                category.type = expenseType;
                              });
                              context.read<CreateCategoryBloc>().add(CreateCategory(category));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
