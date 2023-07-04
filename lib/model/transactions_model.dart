import 'dart:convert';

List<Transactions> modelTransactionsFromJson(String str) => List<Transactions>.from(json.decode(str).map((x) => Transactions.fromJson(x)));
String modelTransactionsToJson(List<Transactions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transactions {
  StatementList? statementlist;

  Transactions({this.statementlist});

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    statementlist: StatementList.fromJson(json["statementlist"]),
  );
  Map<String, dynamic> toJson() => {
    "statementlist": statementlist?.toJson(),
  };

}

class StatementList {
  int? amount;
  String? postingDate;
  String? description;

  StatementList({this.amount, this.postingDate, this.description});

  factory StatementList.fromJson(Map<String, dynamic> json) => StatementList (
    amount : json['amount'],
    postingDate : json['posting_date'],
    description : json['Description'],
  );

  Map<String, dynamic> toJson() => {
    "amount" : amount,
    "posting_date" : postingDate,
    "Desciption" : description,
  };
}