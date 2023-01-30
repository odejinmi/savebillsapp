import 'dart:convert';


class ContactInfo {
  var general,navigation,styling,
      permissions,performance,services;

  ContactInfo({
    this.general,
    this.navigation,
    this.styling,
    this.permissions,
    this.performance,
    this.services,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : general = json['general'],
        navigation = json['navigation'],
        styling = json['styling'],
        permissions = json['permissions'],
        performance = json['performance'],
        services = json['services'];

  Map<String, dynamic> toJson() => {
    'general': general,
    'navigation': navigation,
    'styling': styling,
    'permissions': permissions,
    'performance': performance,
    'services': services,
  };


  @override
  String toString() => json.encode(this);
}