// ignore_for_file: public_member_api_docs, sort_constructors_first

class Call {
  final String callerId;
  final String callerNmae;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialed;
  Call({
    required this.callerId,
    required this.callerNmae,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialed,
  });

  Call copyWith({
    String? callerId,
    String? callerNmae,
    String? callerPic,
    String? receiverId,
    String? receiverName,
    String? receiverPic,
    String? callId,
    bool? hasDialed,
  }) {
    return Call(
      callerId: callerId ?? this.callerId,
      callerNmae: callerNmae ?? this.callerNmae,
      callerPic: callerPic ?? this.callerPic,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverPic: receiverPic ?? this.receiverPic,
      callId: callId ?? this.callId,
      hasDialed: hasDialed ?? this.hasDialed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerNmae': callerNmae,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialed': hasDialed,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerNmae: map['callerNmae'] as String,
      callerPic: map['callerPic'] as String,
      receiverId: map['receiverId'] as String,
      receiverName: map['receiverName'] as String,
      receiverPic: map['receiverPic'] as String,
      callId: map['callId'] as String,
      hasDialed: map['hasDialed'] as bool,
    );
  }
}
