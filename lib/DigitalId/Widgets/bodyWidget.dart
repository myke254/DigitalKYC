import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  String? pName,
      pUrl,
      pVillage,
      pfather,
      pmother,
      pgrandmother,
      pgrandfather,
      plastname;

  BodyWidget(
      {Key? key,
      this.pName,
      this.pUrl,
      this.pVillage,
      this.pfather,
      this.pgrandfather,
      this.pgrandmother,
      this.pmother,
      this.plastname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 11,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 6, // red as border color
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          child: Container(
                            color: Colors.blue,
                            child: (pUrl == null)
                                ? const Center(
                                    child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 50,
                                  ))
                                : CachedNetworkImage(
                                    imageUrl: '$pUrl',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
//
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                          onTap: () {},
                          // onTap: () => showDialog(
                          //     context: context,
                          //     barrierDismissible: true,
                          //     builder: (context) => GetImage(
                          //           pUrl: pUrl!,
                          //         )),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            //color: Colors.green,
                            child: Center(
                                child: Text(
                              '$pName  $plastname',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            decoration: const BoxDecoration(
                                // color: Colors.green
                                ),
                          ),
                          onTap: () {},
                          // onTap: () => showDialog(
                          //     context: context,
                          //     barrierDismissible: true,
                          //     builder: (context) => GetName(
                          //           pName: pName!,
                          //           pVillage: pVillage!,
                          //         )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 6, // red as border color
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      ),
                      const Text(
                        "Father Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text('$pfather'),
                      ),
                      const Text(
                        "Mother Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text('$pmother'),
                      ),
                      const Text(
                        "Grand Father Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text('$pgrandfather'),
                      ),
                      const Text(
                        "GrandMother Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text('$pgrandmother'),
                      ),
                      const Text(
                        "Village",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text('$pVillage'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
