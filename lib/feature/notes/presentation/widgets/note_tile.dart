import 'package:flutter/material.dart';

import '../../../../core/utils/priority_helper.dart';

class NoteTile extends StatelessWidget {

  final String title;
  final String date;
  final int priority;
  final int isSynced;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteTile({
    super.key,
    required this.title,
    required this.date,
    required this.priority,
    required this.isSynced,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: ListTile(

        onTap: onTap,

        /// PRIORITY
        leading: CircleAvatar(

          backgroundColor: PriorityHelper.getPriorityColor(priority,),

          child:  PriorityHelper .getPriorityIcon(priority,
          ),
        ),

        /// TITLE
        title:  Text(
          "isSynced: $isSynced",
        ),
        //Text(title),

        /// DATE
        subtitle: Text(date),

        /// DELETE
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSynced == 1
                  ? Icons.cloud_done
                  : Icons.cloud_off,
              color: isSynced == 1
                  ? Colors.green
                  : Colors.red,
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}