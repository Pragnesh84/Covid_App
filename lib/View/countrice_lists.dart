import 'package:covid_app/Model/CountriceName.dart';
import 'package:covid_app/Services/state_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CountriceLists extends StatefulWidget {
  const CountriceLists({super.key});

  @override
  State<CountriceLists> createState() => _CountriceListsState();
}

class _CountriceListsState extends State<CountriceLists> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: searchController,
                onChanged: (value){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search Countrice Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                  future: stateServices.countriceListApi(),
                    builder: (context, AsyncSnapshot<List<dynamic>>snapshot){
                      if(!snapshot.hasData){
                       return ListView.builder(
                           itemCount: 10,
                           itemBuilder: (context, index){
                             return Shimmer.fromColors(
                                 baseColor: Colors.grey.shade700,
                                 highlightColor:Colors.grey.shade100,
                               child: Column(
                                 children: [
                                   ListTile(
                                     title: Container(height:10,width: 80,color: Colors.white),
                                     subtitle: Container(height:10,width: 80,color: Colors.white),
                                     leading: Container(height:50,width: 50,color: Colors.white),
                                   ),
                                 ],
                               ),
                             );
                           });
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                            String name = snapshot.data![index]["country"];
                            if(searchController.text.isEmpty){
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data![index]["country"]),
                                    subtitle: Text(snapshot.data![index]["cases"].toString()),
                                    leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]["countryInfo"]["flag"]
                                        )),
                                  ),
                                ],
                              );
                            }else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data![index]["country"]),
                                    subtitle: Text(snapshot.data![index]["cases"].toString()),
                                    leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]["countryInfo"]["flag"]
                                        )),
                                  ),
                                ],
                              );
                            }else{
                              return Container();
                            }
                            });
                      }
                    }),
            ),
          ],
        ),
      )
    );
  }
}
