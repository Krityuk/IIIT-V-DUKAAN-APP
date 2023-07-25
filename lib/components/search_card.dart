import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/constants/colors.dart';

import '../constants/validators.dart';
import '../modals/product_model.dart';

class SearchCard extends StatelessWidget {
  final String address;
  final Products product;
  const SearchCard({
    required this.address,
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.document!['images'][0],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\u{20b9} ${product.price != null ? intToStringFormatter(product.price) : ''}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        product.description ?? '',
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.postDate != null
                              ? 'Posted At: ${formattedTime(product.postDate)}'
                              : ''),
                          const SizedBox(height: 10),
                          if (product.document!['isDeleted'] == true)
                            Text(
                              "SOLD",
                              style: TextStyle(color: redColor),
                            )
                          else
                            Text(
                              "AVAILABLE",
                              style: TextStyle(color: greenColor),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
