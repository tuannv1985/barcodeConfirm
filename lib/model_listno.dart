class DataModel {
  String? RowID;
  String? CaseNo;
  String? OWCheckListNo;
  String? FTFinishDate;
  bool? checkbox = true;
  String? FTPlaceCode;

  DataModel({this.RowID, this.CaseNo, this.OWCheckListNo, required this.FTFinishDate, this.checkbox, this.FTPlaceCode});

  DataModel.fromJson(Map<String, dynamic> json) {
    RowID = json['RowID'];
    CaseNo = json['CaseNo'];
    OWCheckListNo = json['OWCheckListNo'];
    FTFinishDate = json['FTFinishDate'];
    FTPlaceCode = json['FTPlaceCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.RowID;
    data['FTFinishDate'] = this.FTFinishDate;
    return data;
  }
}