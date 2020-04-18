import 'package:bot_toast/bot_toast.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:flutter/material.dart';

void showMessage(String title, String subtitle,
    NotificationMessageType notificationMessageType) {
  BotToast.showNotification(
      trailing: (_) => Icon(
            Icons.arrow_forward_ios,
            color: notificationMessageType == NotificationMessageType.SUCCESS
                ? Colors.green
                : Colors.green,
          ),
      title: (_) => Text(title,
          style: TextStyle(
            color: notificationMessageType == NotificationMessageType.SUCCESS
                ? Colors.green
                : Colors.green,
          )),
      subtitle: (_) => Text(subtitle,
          style: TextStyle(
            color: notificationMessageType == NotificationMessageType.SUCCESS
                ? Colors.green
                : Colors.green,
          )),
      leading: (_) => Icon(
            Icons.person,
            color: notificationMessageType == NotificationMessageType.SUCCESS
                ? Colors.green
                : Colors.green,
          ));
}
