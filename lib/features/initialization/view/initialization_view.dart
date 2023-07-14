import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/initialization_controller.dart';
import 'package:shimmer/shimmer.dart';

class InitializationView extends ConsumerStatefulWidget {
  const InitializationView({super.key});

  @override
  ConsumerState<InitializationView> createState() => _InitializationViewState();
}

class _InitializationViewState extends ConsumerState<InitializationView> {
  @override
  void initState() {
    ref
        .read(initializationControllerProvider.notifier)
        .initializeData(context, ref);
    // ref
    //     .read(initializationControllerProvider.notifier)
    //     .initializeCurrentUser(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          leading: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Country',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: const [
            // IconButton(
            //   onPressed: null,
            //   icon: Icon(Icons.looks_one_outlined),
            // ),
            // SizedBox(width: 10),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.chat),
            ),
            SizedBox(width: 10),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight * 1.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    // const Card(
                    //   color: Color(0xFFE3ECFF),
                    //   elevation: 0,
                    //   child: SizedBox(
                    //     height: 50,
                    //     width: 45,
                    //     child: IconButton(
                    //       onPressed: null,
                    //       icon: Icon(Icons.add),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 5),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: SearchBar(
                          leading: const Icon(Icons.search),
                          elevation: const MaterialStatePropertyAll(0.5),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20)),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Card(
                      color: Color(0xFFE3ECFF),
                      elevation: 0,
                      child: SizedBox(
                        height: 50,
                        width: 45,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 15,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4.25,
          ),
          itemCount: 10,
          itemBuilder: (context, index) => GridTile(
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.width > 360 ? 190 : 170,
                        width: double.infinity,
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.blue.shade50,
                          child: Image.network(
                            'https://images.unsplash.com/flagged/photo-1557427161-4701a0fa2f42?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    dense: true,
                    minLeadingWidth: 0,
                    title: Container(
                      color: Colors.grey.shade400,
                      child: Text(
                        'Breed Name',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                    subtitle: Container(
                      color: Colors.grey.shade300,
                      child: Text(
                        '20.1 km away',
                        style: TextStyle(color: Colors.grey.shade300),
                      ),
                    ),
                    trailing: Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.favorite_outline,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
