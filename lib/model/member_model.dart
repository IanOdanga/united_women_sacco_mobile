class AccountsResponseModel{
  late String? memberNo;
  late String? name;
  late String? idNumber;
  late String? telephone;
  late String? accountNumber;
  late String? email;
  late String? accountType;
  late double? accountBalance;

  AccountsResponseModel({
    this.memberNo,
    this.name,
    this.idNumber,
    this.telephone,
    this.accountNumber,
    this.email,
    this.accountType,
    this.accountBalance
  });

  factory AccountsResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountsResponseModel(
      memberNo: json["Member_No"] ?? "",
      name: json["Name"] ?? "",
      idNumber: json["idNumber"] ?? "",
      telephone: json["Telephone"] ?? "",
      accountNumber: json["AccountNumber"] ?? "",
      email: json["email"] ?? "",
      accountType: json["Account_Type"] ?? "",
      accountBalance: json["Account_Balance"] ?? "",
    );
  }
}
