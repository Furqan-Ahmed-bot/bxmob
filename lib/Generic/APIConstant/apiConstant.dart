class ApiConstant {
  // static const baseURL = "http://5.189.169.34:9819/";
  static const baseURLLocal = "http://5.189.169.34:9819/";
  static const baseHost = "5.189.169.34";
  static const baseHostPort = 9819;
  static const appKey = "tssys";

  static Map<String, Map<String, dynamic>> clientAPIs = {
    // TEST
    'ts': {
      'scheme': 'http',
      'baseURLLocal': 'http://10.1.1.13:8081/',
      'baseHost': '10.1.1.13',
      'baseHostPort': 8081,
      'TSAuthSign': '41c45a6a-0928-4c79-bd71-0b7f65637e28',
    },
    'tssys': {
      'baseURLLocal': 'http://tsws2.tsmining.com:9819/',
      //'http://10.1.0.115:8081/',
    }, //backup ts server
    'tssys2': {
      'baseURLLocal': 'http://tsws.tsmining.com:9819/',
      // 'http://10.1.0.115:8081/'
    },
  };
}
