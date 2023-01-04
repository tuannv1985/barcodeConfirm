class DriverModel {
  String? RowID;
  String? CaseNo;
  String? OWCheckListNo;
  String? FTFinishDate;
  String? FTPlaceCode;
  String? OWTruckNo;
  String? OWDeliveryEmployeeCode;

  DriverModel({this.RowID, this.CaseNo, this.OWCheckListNo, required this.FTFinishDate, this.FTPlaceCode,
    this.OWDeliveryEmployeeCode, this.OWTruckNo});

  DriverModel.fromJson(Map<String, dynamic> json) {
    RowID = json['RowID'];
    CaseNo = json['CaseNo'];
    OWCheckListNo = json['OWCheckListNo'];
    FTFinishDate = json['FTFinishDate'];
    FTPlaceCode = json['FTPlaceCode'];
    OWDeliveryEmployeeCode = json['OWDeliveryEmployeeCode'];
    OWTruckNo = json['OWTruckNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.RowID;
    data['FTFinishDate'] = this.FTFinishDate;
    return data;
  }
}