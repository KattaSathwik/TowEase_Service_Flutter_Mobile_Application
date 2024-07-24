class UserRole {
  String? email;
  String? role;
  String? uid;
  String? name;
  String? phNo;
  String? pass;
  String? location;

// receiving data
  UserRole(
      {this.uid,
      this.email,
      this.role,
      this.name,
      this.phNo,
      this.pass,
      this.location});

  factory UserRole.fromMap(map) {
    return UserRole(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      phNo: map['phNo'],
      pass: map['pass'],
      location: map['location'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'phNo': phNo,
      'pass': pass
    };
  }

  Map<String, dynamic> locToMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'phNo': phNo,
      'pass': pass,
      'location': location
    };
  }
}

class UserSendDetails {
  String? id;
  String? name;
  String? location;
  String? sendReq;
  String? vecType;
  String? bookingStatus;

// receiving data
  UserSendDetails(
      {this.id,
      this.name,
      this.location,
      this.sendReq,
      this.vecType,
      this.bookingStatus});

  factory UserSendDetails.fromMap(map) {
    return UserSendDetails(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      sendReq: map['sendReq'],
      vecType: map['vecType'],
      bookingStatus: map['bookingStatus'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'sendReq': sendReq,
      'vecType': vecType,
      'bookingStatus' : bookingStatus
    };
  }
}

class UserSendDetailsAccDriWork {
  String? id;
  String? name;
  String? location;
  String? sendReq;
  String? vecType;
  String? bookingStatus;

// receiving data
  UserSendDetailsAccDriWork(
      {this.id,
        this.name,
        this.location,
        this.sendReq,
        this.vecType,
        this.bookingStatus});

  factory UserSendDetailsAccDriWork.fromMap(map) {
    return UserSendDetailsAccDriWork(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      sendReq: map['sendReq'],
      vecType: map['vecType'],
      bookingStatus: map['bookingStatus'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'sendReq': sendReq,
      'vecType': vecType,
      'bookingStatus' : bookingStatus
    };
  }
}

class UsersAcceptedDetails {
  String? id;
  String? servicername;
  String? username;
  String? usernameid;
  String? servicernameid;
  //String? servicerlocation;
  String? userlocation;
  String? sendReq;
  String? vecType;
  String? bookingStatus;

// receiving data
  UsersAcceptedDetails(
      {this.id,
        this.servicername,
        this.username,
        this.usernameid,
        this.servicernameid,
        this.userlocation,
        this.sendReq,
        this.vecType,
        this.bookingStatus});

  factory UsersAcceptedDetails.fromMap(map) {
    return UsersAcceptedDetails(
      id: map['id'],
      servicername: map['servicername'],
      username: map['username'],
      usernameid: map['usernameid'],
      servicernameid: map['servicernameid'],
      userlocation: map['userlocation'],
      sendReq: map['sendReq'],
      vecType: map['vecType'],
      bookingStatus: map['bookingStatus'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'servicername': servicername,
      'username': username,
      'usernameid': usernameid,
      'servicernameid': servicernameid,
      'userlocation': userlocation,
      'sendReq': sendReq,
      'vecType': vecType,
      'bookingStatus' : bookingStatus
    };
  }
}

