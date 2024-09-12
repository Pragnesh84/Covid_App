import 'dart:async';
import 'package:covid_app/Model/WorldStatesModel.dart';
import 'package:covid_app/Services/state_services.dart';
import 'package:covid_app/View/countrice_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this)..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xffCB3505),
    const Color(0xffC58204),
    const Color(0xffF1EE04),
  ];


  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  FutureBuilder(
                      future: stateServices.fetchWorldStateApi(),
                      builder: (context, AsyncSnapshot<WorldStatesModel> snapshot){
                        if(!snapshot.hasData){
                          return Expanded(
                            flex: 1,
                              child: SpinKitFadingCircle(
                                color: Colors.white,
                                size: 50,
                                controller: _controller,
                              ));
                        }else{
                          return Column(
                            children: [
                              PieChart(
                                dataMap: {
                                  "Total": double.parse(snapshot.data!.cases!.toString()),
                                  "Recovered":double.parse(snapshot.data!.recovered.toString()),
                                  "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                                },
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValuesInPercentage: true,
                                ),
                                legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.left,
                                ),
                                animationDuration: const Duration(milliseconds: 1200),
                                chartType: ChartType.ring,
                                colorList: colorList,
                                chartRadius: MediaQuery.of(context).size.width/ 3.5,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .05),
                                child: Card(
                                  child: Column(
                                    children: [
                                      ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                      ReusableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                      ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                      ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                      ReusableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                      ReusableRow(title: 'Today Case', value: snapshot.data!.todayCases.toString()),
                                      ReusableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                                      ReusableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CountriceLists()));
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:const Color(0xffD08433),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child:const Center(
                                    child: Text("Track Countries"),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ],
              ),
            )),
      )
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key,required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 1),
        ],
      ),
    );
  }
}

