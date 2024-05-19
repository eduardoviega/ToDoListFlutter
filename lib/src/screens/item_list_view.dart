import 'package:flutter/material.dart';
import 'package:to_do_list/src/service/api_service.dart';
import 'package:rxdart/rxdart.dart';

import '../model/list_item.dart';

class ItemListView extends StatefulWidget {
  ItemListView({
    super.key,
  });

  static const routeName = '/';
  final itemList = BehaviorSubject<List<Item>>();
  Stream<List<Item>> get outList => itemList.stream;
  Function(List<Item>) get changeList => itemList.sink.add;
  List<Item> get getList => itemList.value;

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  List<Item> items = [];
  TextEditingController tituloPagina =
      TextEditingController(text: "Lista de compras");
  late ApiService apiService;

  @override
  void initState() {
    apiService = ApiService();
    buscarItens();
    super.initState();
  }

  Future<void> buscarItens() async {
    widget.changeList(await apiService.getItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400.withOpacity(0.9),
        elevation: 5,
        shadowColor: Colors.transparent.withOpacity(0.5),
        title: Padding(
          padding: const EdgeInsets.only(left: 52),
          child: TextFormField(
            controller: tituloPagina,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () async => await buscarItens(),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: widget.outList,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.isNotEmpty
              ? ListView.builder(
                  restorationId: 'itemListView',
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data![index];
                    return Dismissible(
                      key: ValueKey<int>(item.id),
                      confirmDismiss: (direction) async =>
                          await _messageExcluir(),
                      onDismissed: (direction) async {
                        await apiService.deleteItem(snapshot.data![index]).then(
                              (value) async => await buscarItens(),
                            );
                      },
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.red.shade400,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.delete_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CheckboxListTile(
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent.withOpacity(0.1),
                            width: 0.5,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        value: item.isChecked,
                        onChanged: (bool? value) async {
                          item.isChecked = value ?? false;
                          await apiService.updateItem(item).then(
                                (value) async => await buscarItens(),
                              );
                        },
                        tileColor: item.isChecked
                            ? Colors.green.withOpacity(0.2)
                            : Colors.transparent,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green.shade700,
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("Nenhum item na lista!"),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _messageAdicionar();
        },
        elevation: 8,
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Modal para Adicionar item
  _messageAdicionar() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController descricaoController = TextEditingController(text: "");
    await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Adicionar item na lista'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(
              hintText: 'Descrição do item',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Adicione um texto';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey.shade500),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green.shade300),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Item item = Item(
                  isChecked: false,
                  name: descricaoController.text,
                );
                descricaoController.clear();
                await apiService.createItem(item).then(
                  (value) async {
                    (value) => Navigator.pop(context);
                    await buscarItens();
                  },
                );
              }
            },
            child: const Text(
              'Adicionar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Modal para confirmar exclusão
  _messageExcluir() async {
    bool resposta = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Excluir'),
        content: const Text('Deseja mesmo remover este item?'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade500)),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.red.shade400)),
            onPressed: () => {
              resposta = true,
              Navigator.pop(context),
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return resposta;
  }
}
