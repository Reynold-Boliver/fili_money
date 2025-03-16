import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fili_money/theme/color.dart';
import 'package:string_similarity/string_similarity.dart';

class CustomDropdownSearch extends StatefulWidget {
  final String? errorMessage;
  final TextEditingController controller;

  /// Map of category titles to a description (or type)
  final Map<String, String> categories;

  /// Map of category description/type to a color
  final Map<String, Color> categoryColors;

  const CustomDropdownSearch({
    super.key,
    required this.controller,
    this.errorMessage,
    required this.categories,
    required this.categoryColors,
  });

  @override
  State<CustomDropdownSearch> createState() => _CustomDropdownSearchState();
}

class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
  String? selectedValue;

  List<String> getFilteredResults(String searchQuery) {
    if (searchQuery.isEmpty) {
      return widget.categories.keys.toList();
    }

    searchQuery = searchQuery.toLowerCase();
    List<String> searchResults = [];

    debugPrint("🔍 Searching for: $searchQuery");

    // First, try to match exact names or types.
    for (var entry in widget.categories.entries) {
      String category = entry.key.toLowerCase();
      String type = entry.value.toLowerCase();

      if (type == searchQuery || category == searchQuery) {
        if (!searchResults.contains(entry.key)) {
          searchResults.insert(0, entry.key);
        }
      }
    }

    // Then, look for partial matches in type.
    for (var entry in widget.categories.entries) {
      if (entry.value.toLowerCase().contains(searchQuery)) {
        if (!searchResults.contains(entry.key)) {
          searchResults.add(entry.key);
        }
      }
    }

    // Then, look for partial matches in category title.
    for (var entry in widget.categories.entries) {
      if (entry.key.toLowerCase().contains(searchQuery)) {
        if (!searchResults.contains(entry.key)) {
          searchResults.add(entry.key);
        }
      }
    }

    // Lastly, use string similarity.
    for (var entry in widget.categories.entries) {
      double valueSimilarity = entry.value.toLowerCase().similarityTo(searchQuery);
      double keySimilarity = entry.key.toLowerCase().similarityTo(searchQuery);

      if (valueSimilarity >= 0.5 || keySimilarity >= 0.5) {
        if (!searchResults.contains(entry.key)) {
          searchResults.add(entry.key);
        }
      }
    }

    debugPrint("📋 Final search results: $searchResults");
    return searchResults;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Expense Type',
            style: const TextStyle(
              color: AppPalette.teal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: widget.errorMessage != null
                ? Border.all(color: Colors.red, width: 1.5)
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white10,
                offset: const Offset(-6, -6),
                blurRadius: 6,
              ),
              BoxShadow(
                color: AppPalette.teal.withAlpha(80),
                offset: const Offset(6, 6),
                blurRadius: 6,
              ),
            ],
          ),
          child: DropdownSearch<String>(
            mode: Mode.form,
            items: (filter, cs) => widget.categories.keys.toList(),
            filterFn: (item, filter) => getFilteredResults(filter).contains(item),
            selectedItem: selectedValue,
            popupProps: PopupProps.dialog(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: const InputDecoration(
                  hintText: "Search Finance category...",
                  border: OutlineInputBorder(),
                ),
              ),
              dialogProps: DialogProps(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              itemBuilder: (context, item, isDisabled, isSelected) {
                // Get the description (or type) for the current category.
                final categoryDescription = widget.categories[item] ?? '';
                // Use the description to look up the color.
                final categoryColor = widget.categoryColors[categoryDescription] ?? Colors.grey;

                return ListTile(
                  title: Text(
                    item,
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    categoryDescription,
                    style: TextStyle(
                      color: categoryColor.withAlpha(125),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.23),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select a category";
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.controller.text = value ?? "";
            },
            dropdownBuilder: (context, selectedItem) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Text(
                  selectedItem ?? "Select a category",
                  style: const TextStyle(
                    color: AppPalette.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
