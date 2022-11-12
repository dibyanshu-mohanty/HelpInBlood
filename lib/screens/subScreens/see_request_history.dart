import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/donor_provider.dart';

class SeeRequestHistory extends StatelessWidget {
  final String phone;
  const SeeRequestHistory({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<Donors>(context, listen: false).clearLists();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: Container(
            height: 100.h,
            width: 100.w,
            child: FutureBuilder(
                future: Provider.of<Donors>(context, listen: false)
                    .checkRequestHistory(context, phone),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(strokeWidth: 2.0,),);
                  }
                  return Consumer<Donors>(
                    child: Center(child: Text("No requests found !",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w500),),),
                      builder: (context, data, child) {
                        if(data.requests.isEmpty){
                          return child!;
                        }
                        return ListView.builder(
                          itemCount: data.requests.length,
                            itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey,
                              ),
                              child: ExpansionTile(
                                collapsedTextColor: Colors.grey,
                                leading: const CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.bloodtype),
                                ),
                                title: Text(data.requests[index]["time"],style: TextStyle(color: Colors.white),),
                                subtitle: Text(data.requests[index]["requiredBlood"].toString(),style: TextStyle(color: Colors.white),),
                                trailing: Icon(Icons.done,color: Colors.white,),
                                children: data.donors.map((e){
                                  return ListTile(
                                      title: Text(e["name"],style: TextStyle(color: Colors.white),),
                                      subtitle: Text(e["phone"],style: TextStyle(color: Colors.white),),
                                      trailing: Text(e["bloodGroup"],style: TextStyle(color: Colors.white),),
                                  );
                                }
                                ).toList()
                              ),
                            );
                    });
                  });
                })));
  }
}


