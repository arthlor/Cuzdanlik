import 'package:flutter/material.dart';

class Pagination<T> extends StatefulWidget {
  final List<T> items;
  final int itemsPerPage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const Pagination({
    super.key,
    required this.items,
    required this.itemsPerPage,
    required this.itemBuilder,
  });

  @override
  _PaginationState<T> createState() => _PaginationState<T>();
}

class _PaginationState<T> extends State<Pagination<T>> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage) < widget.items.length
        ? (startIndex + widget.itemsPerPage)
        : widget.items.length;
    final itemsToDisplay = widget.items.sublist(startIndex, endIndex);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itemsToDisplay.length,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, itemsToDisplay[index], index);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0
                  ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: currentPage > 0 ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
            ),
            Text(
              '${currentPage + 1} / ${(widget.items.length / widget.itemsPerPage).ceil()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: endIndex < widget.items.length
                  ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: endIndex < widget.items.length ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.chevron_right, size: 32, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (widget.items.length / widget.itemsPerPage).ceil(),
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
