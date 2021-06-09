class chatMessage{
  String content;
  bool  isSend;

  chatMessage({this.content, this.isSend});

  factory chatMessage.fromJson(Map<String, dynamic> json) => chatMessage(
      content: json['content'],
      isSend: json['isSend']);
}