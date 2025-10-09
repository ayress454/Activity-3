import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _itemNameCtrl = TextEditingController();
  double _price = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Add-Ons Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemNameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Add-On Name (e.g., Decorations)'),
            ),
            TextField(
              onChanged: (val) => _price = double.tryParse(val) ?? 0.0,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final cart = context.read<CartProvider>(); // One-time read
                if (_itemNameCtrl.text.isNotEmpty && _price > 0) {
                  cart.addItem(_itemNameCtrl.text, _price);
                  _itemNameCtrl.clear();
                  setState(() => _price = 0.0);
                }
              },
              child: const Text('Add to Cart'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<CartProvider>(
                // Reactive watch
                builder: (context, cart, child) {
                  if (cart.items.isEmpty) {
                    return const Center(child: Text('Cart is empty'));
                  }
                  return ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => cart.removeItem(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, child) => Text(
                'Total: \$${cart.total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemNameCtrl.dispose();
    super.dispose();
  }
}
