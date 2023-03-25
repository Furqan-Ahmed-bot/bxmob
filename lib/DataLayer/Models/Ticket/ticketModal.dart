

// class ClientInformationModel {
//   List<Null>? TaskTypeList;
//   List<Null>? JobTypeList;
//   Null? contactPersonList;
//   List<PriorityList>? priorityList;

//   ClientInformationModel(
//       {this.TaskTypeList,
//       this.JobTypeList,
//       this.contactPersonList,
//       this.priorityList});

// }

// //   ClientInformationModel.fromJson(Map<String, dynamic> json) {
// //     if (json['TaskTypeList'] != null) {
// //       TaskTypeList = <Null>[];
// //       json['TaskTypeList'].forEach((v) {
// //         // taskTypeList!.add(new Null);
// //       });
// //     }
// //     if (json['JobTypeList'] != null) {
// //       JobTypeList = <Null>[];
// //       json['JobTypeList'].forEach((v) {
// //         // jobTypeList!.add(new Null.fromJson(v));
// //       });
// //     }
// //     contactPersonList = json['ContactPersonList'];
// //     if (json['PriorityList'] != null) {
// //       priorityList = <PriorityList>[];
// //       json['PriorityList'].forEach((v) {
// //         priorityList!.add(new PriorityList.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.TaskTypeList != null) {
// //       data['TaskTypeList'] = TaskTypeList;
// //     }
// //     if (this.JobTypeList != null) {
// //       data['JobTypeList'] = JobTypeList;
// //     }
// //     data['ContactPersonList'] = contactPersonList;
// //     if (this.priorityList != null) {
// //       data['PriorityList'] = priorityList!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// class PriorityList {
//   int? priorityId;
//   String? name;
//   String? shortName;
//   String? dataEntryDate;
//   int? dataEntryStatus;
//   String? colrCode;

//   PriorityList(
//       {this.priorityId,
//       this.name,
//       this.shortName,
//       this.dataEntryDate,
//       this.dataEntryStatus,
//       this.colrCode});

//   PriorityList.fromJson(Map<String, dynamic> json) {
//     priorityId = json['PriorityId'];
//     name = json['Name'];
//     shortName = json['ShortName'];
//     dataEntryDate = json['DataEntryDate'];
//     dataEntryStatus = json['DataEntryStatus'];
//     colrCode = json['ColrCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['PriorityId'] = this.priorityId;
//     data['Name'] = this.name;
//     data['ShortName'] = this.shortName;
//     data['DataEntryDate'] = this.dataEntryDate;
//     data['DataEntryStatus'] = this.dataEntryStatus;
//     data['ColrCode'] = this.colrCode;
//     return data;
//   }
// }

// // class ClientInformationModel {
// //   List<PriorityList>? priorityList;

// //   ClientInformationModel({this.priorityList});

// //   ClientInformationModel.fromJson(Map<String, dynamic> json) {
// //     if (json['PriorityList'] != null) {
// //       priorityList = <PriorityList>[];
// //       json['PriorityList'].forEach((v) {
// //         priorityList!.add(new PriorityList.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.priorityList != null) {
// //       data['PriorityList'] = this.priorityList!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// // class PriorityList {
// //   int? priorityId;
// //   String? name;
// //   String? shortName;
// //   String? dataEntryDate;
// //   int? dataEntryStatus;
// //   String? colrCode;

// //   PriorityList(
// //       {this.priorityId,
// //       this.name,
// //       this.shortName,
// //       this.dataEntryDate,
// //       this.dataEntryStatus,
// //       this.colrCode});

// //   PriorityList.fromJson(Map<String, dynamic> json) {
// //     priorityId = json['PriorityId'];
// //     name = json['Name'];
// //     shortName = json['ShortName'];
// //     dataEntryDate = json['DataEntryDate'];
// //     dataEntryStatus = json['DataEntryStatus'];
// //     colrCode = json['ColrCode'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['PriorityId'] = this.priorityId;
// //     data['Name'] = this.name;
// //     data['ShortName'] = this.shortName;
// //     data['DataEntryDate'] = this.dataEntryDate;
// //     data['DataEntryStatus'] = this.dataEntryStatus;
// //     data['ColrCode'] = this.colrCode;
// //     return data;
// //   }
// // }



// ignore_for_file: non_constant_identifier_names, empty_constructor_bodies

class TicketModel{
 String? ContactPersonId;
 String? JobTypeId;
 String? TaskTypeId;
 String? PriorityId;

 TicketModel({this.ContactPersonId , this.JobTypeId , this.TaskTypeId , this.PriorityId});

 TicketModel.fromJson(Map<String, dynamic> json){
  ContactPersonId = json['ContactPersonId'];
  JobTypeId = json['JobTypeId'];
  TaskTypeId = json['TaskTypeId'];
  PriorityId = json['PriorityId']; 


 }

  Map<String, dynamic> toJson(){
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['ContactPersonId'] = this.ContactPersonId;
  data['JobTypeId'] = this.JobTypeId;
  data['TaskTypeID'] = this.TaskTypeId;
  data['PriorityId'] = this.PriorityId;

  return data;

  }





}
