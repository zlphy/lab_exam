import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool hasSeenOnboarding = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryPal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: hasSeenOnboarding
          ? InventoryScreen(
              onThemeChanged: (isDark) {
                setState(() {
                  isDarkMode = isDark;
                });
              },
            )
          : OnboardingScreen(
              onComplete: () {
                setState(() {
                  hasSeenOnboarding = true;
                });
              },
            ),
    );
  }
}

// Data Model
class InventoryItem {
  String name;
  int quantity;
  DateTime expiryDate;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.expiryDate,
  });

  InventoryItem copyWith({
    String? name,
    int? quantity,
    DateTime? expiryDate,
  }) {
    return InventoryItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}

// Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: '🎉 Welcome to PantryPal',
      description: 'Manage your pantry inventory effortlessly',
      icon: Icons.shopping_bag,
      backgroundColor: Colors.green.shade100,
    ),
    OnboardingPage(
      title: '📦 Track Your Items',
      description:
          'Add items, set quantities, and track expiry dates to avoid waste',
      icon: Icons.inventory_2,
      backgroundColor: Colors.blue.shade100,
    ),
    OnboardingPage(
      title: '🛒 Smart Shopping',
      description:
          'Create and organize your shopping list with drag-and-drop reordering',
      icon: Icons.shopping_cart,
      backgroundColor: Colors.orange.shade100,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return OnboardingPageWidget(page: pages[index]);
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Skip button
            TextButton(
              onPressed: () => widget.onComplete(),
              child: const Text('Skip'),
            ),
            // Dots indicator
            Row(
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 30 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            // Next or Get Started button
            _currentPage == pages.length - 1
                ? ElevatedButton(
                    onPressed: () => widget.onComplete(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Get Started'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Next'),
                  ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              page.icon,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            Text(
              page.title,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                page.description,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Inventory Screen (Home)
class InventoryScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;

  const InventoryScreen({super.key, this.onThemeChanged});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  List<InventoryItem> items = [
    InventoryItem(
      name: 'Eggs',
      quantity: 10,
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    InventoryItem(
      name: 'Milk',
      quantity: 2,
      expiryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    InventoryItem(
      name: 'Cheese',
      quantity: 1,
      expiryDate: DateTime.now().add(const Duration(days: 14)),
    ),
    InventoryItem(
      name: 'Butter',
      quantity: 3,
      expiryDate: DateTime.now().add(const Duration(days: 21)),
    ),
    InventoryItem(
      name: 'Bread',
      quantity: 5,
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  String _searchQuery = '';
  bool _isDarkMode = false;
  late AnimationController _fabAnimationController;

  List<InventoryItem> get filteredItems {
    if (_searchQuery.isEmpty) {
      return items;
    }
    return items
        .where((item) =>
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _editItem(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(itemToEdit: items[index]),
      ),
    ).then((editedItem) {
      if (editedItem != null) {
        setState(() {
          items[index] = editedItem;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${editedItem.name} updated')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PantryPal - Inventory'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.1)
                    .animate(_fabAnimationController),
                child: IconButton(
                  icon:
                      Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
                  onPressed: () {
                    _fabAnimationController.forward().then((_) {
                      _fabAnimationController.reverse();
                    });
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                    widget.onThemeChanged?.call(_isDarkMode);
                  },
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.1)
                    .animate(_fabAnimationController),
                child: IconButton(
                  icon: const Icon(Icons.shopping_basket),
                  onPressed: () {
                    _fabAnimationController.forward().then((_) {
                      _fabAnimationController.reverse();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShoppingListScreen(items: items),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Search items...',
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return filteredItems
                    .map((item) => ListTile(
                          title: Text(item.name),
                          onTap: () {
                            controller.text = item.name;
                            setState(() {
                              _searchQuery = item.name;
                            });
                          },
                        ))
                    .toList();
              },
            ),
          ),
          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No items in inventory. Add some!'
                          : 'No items found for "$_searchQuery"',
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final originalIndex = items.indexOf(item);
                      return Dismissible(
                        key: Key(item.name + originalIndex.toString()),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // Left to Right = Edit
                            _editItem(originalIndex);
                            return false;
                          }
                          return true;
                        },
                        onDismissed: (direction) {
                          setState(() {
                            items.removeAt(originalIndex);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} deleted')),
                          );
                        },
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            'Qty: ${item.quantity} | Expires: ${item.expiryDate.toString().split(' ')[0]}',
                          ),
                          leading: CircleAvatar(
                            child: Text(item.quantity.toString()),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final newItem = await Navigator.push<InventoryItem>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItemScreen(),
            ),
          );
          if (newItem != null) {
            setState(() {
              items.add(newItem);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Add Item Screen (Form)
class AddItemScreen extends StatefulWidget {
  final InventoryItem? itemToEdit;

  const AddItemScreen({super.key, this.itemToEdit});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  DateTime? _selectedDate;
  late AnimationController _submitButtonController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.itemToEdit?.name ?? '');
    _quantityController =
        TextEditingController(text: widget.itemToEdit?.quantity.toString() ?? '');
    _selectedDate = widget.itemToEdit?.expiryDate;

    _submitButtonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _submitButtonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      _submitButtonController.forward().then((_) {
        final newItem = InventoryItem(
          name: _nameController.text.trim(),
          quantity: int.parse(_quantityController.text),
          expiryDate: _selectedDate!,
        );
        Navigator.pop(context, newItem);
      });
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemToEdit != null ? 'Edit Item' : 'Add Item'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Milk, Eggs',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Item name cannot be empty';
                  }
                  if (value.trim().length < 3) {
                    return 'Item name must be at least 3 characters';
                  }
                  if (value.trim().length > 20) {
                    return 'Item name must be at most 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantity cannot be empty';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null) {
                    return 'Quantity must be a valid number';
                  }
                  if (quantity <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 16),
                      Text(
                        _selectedDate == null
                            ? 'Select Expiry Date'
                            : 'Expiry: ${_selectedDate!.toString().split(' ')[0]}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _submitButtonController,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 0.95)
                        .animate(_submitButtonController),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveItem,
                        icon: const Icon(Icons.save),
                        label: Text(widget.itemToEdit != null
                            ? 'Update Item'
                            : 'Save Item'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shopping List Screen
class ShoppingListScreen extends StatefulWidget {
  final List<InventoryItem> items;

  const ShoppingListScreen({super.key, required this.items});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with TickerProviderStateMixin {
  late List<InventoryItem> shoppingItems;
  late AnimationController _reorderController;

  @override
  void initState() {
    super.initState();
    // Items that are low in quantity (qty < 5) go to shopping list
    shoppingItems = widget.items.where((item) => item.quantity < 5).toList();

    _reorderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _reorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: shoppingItems.isEmpty
          ? const Center(
              child: Text('No items to buy!'),
            )
          : ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                _reorderController.forward().then((_) {
                  _reorderController.reverse();
                });
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = shoppingItems.removeAt(oldIndex);
                  shoppingItems.insert(newIndex, item);
                });
              },
              children: [
                for (int index = 0; index < shoppingItems.length; index++)
                  AnimatedBuilder(
                    key: Key('item_${shoppingItems[index].name}_$index'),
                    animation: _reorderController,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.05)
                            .animate(_reorderController),
                        child: Container(
                          key: Key('${shoppingItems[index].name}_$index'),
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(shoppingItems[index].name),
                            subtitle: Text(
                              'Qty: ${shoppingItems[index].quantity}',
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}


