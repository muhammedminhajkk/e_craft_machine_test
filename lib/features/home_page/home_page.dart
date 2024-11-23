import 'package:e_craft_machine_test/features/home_page/expence_model/expence_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class HomePage extends HookWidget {
  final String user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final expenses = useState<List<ExpenseModel>>([]);
    final amountController = useTextEditingController();
    final TextEditingController descriptionController =
        useTextEditingController();

    // Categories for dropdown
    final List<String> categories = [
      'Food',
      'Transport',
      'Entertainment',
      'Groceries',
      'Others'
    ];

    // Default selected category
    final ValueNotifier<String> selectedCategory =
        ValueNotifier<String>('Food');

    // Default selected date
    final ValueNotifier<DateTime> defaultdate =
        ValueNotifier<DateTime>(DateTime.now());

    void pickDate(BuildContext context) async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: defaultdate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        defaultdate.value =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      }
    }

    void addExpense(BuildContext context) {
      final double? amount = double.tryParse(amountController.text);
      final String description = descriptionController.text;

      if (amount == null || amount <= 0 || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter valid amount and description.')),
        );
        return;
      }
      expenses.value = [
        ...expenses.value,
        ExpenseModel(
            amount: amount,
            category: selectedCategory.value,
            description: description,
            date: defaultdate.value)
      ];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );

      // Clear fields after adding
      amountController.clear();
      descriptionController.clear();
      selectedCategory.value = 'Food';
      defaultdate.value = DateTime.now();
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          Text(user),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder<String>(
                              valueListenable: selectedCategory,
                              builder: (context, value, _) {
                                return DropdownButtonFormField<String>(
                                  value: value,
                                  items: categories.map((category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      selectedCategory.value = newValue;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder<DateTime>(
                              valueListenable: defaultdate,
                              builder: (context, value, _) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ${value.toLocal()}'.split(' ')[0],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => pickDate(context),
                                      child: const Text('Pick Date'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => addExpense(context),
                                child: const Text('Add Expense'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: expenses.value.length,
        itemBuilder: (context, index) {
          final expense = expenses.value[index];
          final amount = expense.amount;
          final category = expense.category;
          final description = expense.description;
          final DateTime date = expense.date;

          // Format the date to show only the date (without the time)
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color.fromARGB(255, 115, 185, 242),
              width: double.infinity,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(category), Text(description)],
                  ),
                  Text(formattedDate),
                  Text(amount.toString()),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      expenses.value = [...expenses.value..removeAt(0)];
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
