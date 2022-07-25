class FireMessage {
  String? sender;
  String? text;
  String? photo;
  String? time;
  String? audio;
  String? video;
  String? videoThumb;
  double? longitude;
  double? latitude;
  bool? seen;

  String? replyText;
  String? replyVideo;
  String? replyPhoto;

  FireMessage(
      {required this.sender,
      required this.text,
       this.photo,
      required this.time,
       this.audio,
       this.seen,
       this.video,
       this.videoThumb,
       this.longitude,
       this.latitude,
       this.replyVideo,
       this.replyPhoto,
       this.replyText});

  Map toMap(FireMessage user) {
    var data = Map<String, dynamic>();
    data['sender'] = user.sender;
    data['text'] = user.text;
    data["photo"] = user.photo;
    data['time'] = user.time;
    data['audio'] = user.audio;
    data['seen'] = user.seen;
    data['video'] = user.video;
    data['videoThumb'] = user.videoThumb;
    data['longitude'] = user.longitude;
    data['latitude'] = user.latitude;

    data['replyVideo'] = user.replyVideo;
    data['replyPhoto'] = user.replyPhoto;
    data['replyText'] = user.replyText;
    return data;
  }

  // Named constructor
  FireMessage.fromMap(Map<String, dynamic> mapData) {
    sender = mapData['sender'];
    this.text = mapData['text'];
    this.photo = mapData['photo'];
    this.time = mapData['time'];
    this.audio = mapData['audio'];
    this.video = mapData['video'];
    this.videoThumb = mapData['videoThumb'];
    this.seen = mapData['seen'];
    this.longitude = mapData['longitude'];
    this.latitude = mapData['latitude'];

    this.replyVideo = mapData['replyVideo'];
    this.replyPhoto = mapData['replyPhoto'];
    this.replyText = mapData['replyText'];
  }
}
