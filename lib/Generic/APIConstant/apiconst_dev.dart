class ApiConstant {
  // static const baseURL = "http://5.189.169.34:9819/";
  static const baseURLLocal = "http://5.189.169.34:9819/";
  static const baseHost = "5.189.169.34";
  static const baseHostPort = 9819;
  static const appKey = "tssys";

  static Map<String, Map<String, dynamic>> clientAPIs = {
    // TEST
    'ts': {
      'scheme' : 'http',
      'baseURLLocal': 'http://10.1.1.13:8081/',
      'baseHost': '10.1.1.13',
      'baseHostPort': 8081,
      'TSAuthSign': '41c45a6a-0928-4c79-bd71-0b7f65637e28',
    },
    'restaurant_demo': {
      'scheme' : 'http',
      'baseURLLocal': 'http://10.1.1.13:8081/',
      'baseHost': '10.1.1.13',
      'baseHostPort': 8081,
      'url': 'http://10.1.1.13:8080',
      'TSAuthSign': 'aaf47997-3711-45a5-8ea2-bc5f45e768c4',
    },
 //demo
    'demofb': {
      'scheme' : 'http',
      'baseURLLocal': 'http://5.189.169.34:9820/',
      'baseHost': '5.189.169.34',
      'baseHostPort': 9820,
      'TSAuthSign': '7f4311b4-8496-4d16-aae7-c74ccd97ccca',
      
    },

    // VPS
    'image': {
      'scheme' : 'http',
      'baseURLLocal': 'http://182.184.63.201:8081/',
      'baseHost': '182.184.63.201',
      'baseHostPort': 8081,
      'TSAuthSign': '197c6391-d52b-4b5b-b1fa-30acd85222b8',
    },
    //////////////////////////////////////////////TEMP-2022-10-18
    'tssys': {
      'scheme' : 'http',
      'baseURLLocal': 'http://5.189.169.34:9819/',
      'baseHost': '5.189.169.34',
      'baseHostPort': 9819,
      'TSAuthSign': 'ed07f4a5-d6b3-4c8a-bd55-c57e64e4a291',
    },
    //  'tssys': {
    //   'scheme' : 'http',
    //   'baseURLLocal': 'http://5.189.169.34:9819/',
    //   'baseHost': '5.189.169.34',
    //   'baseHostPort': 9819,
    //   'TSAuthSign': 'ed07f4a5-d6b3-4c8a-bd55-c57e64e4a291',
    // },

    'mehran': {
      'scheme' : 'http',
      'baseURLLocal': 'http://203.170.78.100:8098/',
      'baseHost': '203.170.78.100',
      'baseHostPort': 8098,
      'TSAuthSign': '21237743-ccc5-4b3c-a0ba-8f312762b3ce',
    },
    'rainbow': {
      'scheme' : 'http',
      'baseURLLocal': 'http://202.163.76.201:8090/',
      'baseHost': '202.163.76.201',
      'baseHostPort': 8090,
      'TSAuthSign': '24707227-e18a-4b6b-9efe-4e20ed2962a9',
    },
    'foodsinn': {
      'scheme' : 'http',
      'baseURLLocal': 'http://175.107.200.184:8090/',
      'baseHost': '175.107.200.184',
      'baseHostPort': 8090,
      'TSAuthSign':'ed07f4a5-d6b3-4c8a-bd55-c57e64e4a291',
      'url': 'http://fivps.tsmining.com:9003'
       
    },
    'RoyalFashions': {
      'scheme' : 'http',
      'baseURLLocal': 'http://124.29.237.36:8079/',
      'baseHost': '124.29.237.36',
      'baseHostPort': 8079,
      'TSAuthSign': '602c273c-8887-4ea4-bf98-5f4bca33a4cf',
    },
    'rs': {
      'scheme' : 'http',
      'baseURLLocal': 'http://115.42.64.198:8078/',
      'baseHost': '115.42.64.198',
      'baseHostPort': 8078,
      'TSAuthSign': '445f32d3-e502-48c3-8b8c-5962f0abb923',
      
    },
    'dpm': {
      'scheme' : 'http',
      'baseURLLocal': 'http://125.209.124.200:8078/',
      'baseHost': '125.209.124.200',
      'baseHostPort': 8078,
      'TSAuthSign': '6e105b92-8fe8-4bfb-8347-c244100f012c',
    },
    'burgeroclock': {
      'scheme' : 'http',
      'baseURLLocal': 'http://103.245.193.94:9001/',
      'baseHost': '103.245.193.94',
      'baseHostPort': 9001,
      'TSAuthSign': '57d943f0-2bed-48ed-a083-539f9e854005',
    },
    'uk': {
      'scheme' : 'http',
      'baseURLLocal': 'http://125.209.98.102:8085/',
      'baseHost': '125.209.98.102',
      'baseHostPort': 8085,
      'TSAuthSign': 'b581cd4d-ff59-4643-aee2-1e239231560d',
    },
    // AZURE
    'milestone': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '1f67ae08-69df-425a-a1a2-c528a7fb32ad',
    },
    'spring': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'e96a6ae5-6130-4bea-9b7c-56c5aa52109e',
    },
    'BlackNBrown': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'dbd07bf9-41d6-496d-a359-5bfc30b9d786',
    },
    'ochre': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '035f9d98-a4e6-44bb-a43d-41b24a4eb072',
    },
    'walkeaze': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '7e8a7786-b13f-4443-adc4-cc7bcc8a4e59',
    },
    'taanabaana': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '6a5d88e5-3e08-4960-8447-7d0fe74bb3a6',
    },
    'needz': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '4580d200-f764-4d3c-97c3-3458cedac65c',
    },
    'pits': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'f2d9522b-430d-4b92-9ffa-ed7e2e7fa309',
    },
    'gaba': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '3e8d2fbb-fd15-48e3-92f5-398d96c51c7a',
    },
    'dreams': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '39e738cf-a73d-4745-ad05-c5449b16bdc6',
    },
    'btb': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'ed6610d6-76f9-4652-8b2d-39afac9b11ef',
    },
    'newway': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '1e020f6e-0ce9-43f2-b271-b181ff7e38e5',
    },
    'shazz': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'ba396553-1dfa-4175-a451-ae668fe54f1b',
    },
    'califord': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '1170774c-6b3f-4add-9c38-1cf2650d6715',
    },
    'brackets': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '8cd64935-9489-4652-a7dc-0eced68a4b49',
    },
    'royalint': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '1a9736f4-421f-47e7-b74e-25c500227472',
    },
    'easymart': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'cc3bb4fb-29c0-4317-ba63-513386abbb67',
    },
    'acs': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'ba013568-923f-4ea4-afe2-28a2d2ef04f8',
    },
    'Mzf': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '39c3d71c-f61b-40c1-a207-45624fe67158',
    },
    'msf': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '805fcb0e-9084-45c0-96c1-195664cc9689',
    },
    'ihop': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '02f4b4c6-6a37-4ba6-ab05-914fba47303d', 
    },
    'maxbachat': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'c9fbaebf-541a-427b-be16-840704c40318', 
    },
    'jdb': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '692efc5a-0c81-4e08-8904-5784cd47c622',
    },
    'globalmart': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '07e23a2f-f5da-4593-95ef-a77f955df342',
    },
    'acl': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '6f14a29d-b0ac-4ea6-a919-bb55dac55004',
    },
    'limitless': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '96aa885b-70cc-47eb-912e-4be0510f7b97',
    },
    'ultraclub': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'af65fa95-38a9-4e9b-bdf1-0d8d50bc625e',
      
    },
    'cafeimran': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '8d9a2c27-17e8-4213-9c99-62a5872bafe4',
    },
    'appiefarms': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'ba8021fa-6f43-4a32-b848-c18b9f7fcea3',
    },
    'maxmart': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'e05164e1-d5f0-4e00-ba42-5f08d5a0ac1a',
    },
    'standardtea': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '0c03c865-357f-4f31-b494-3338559de25c',
    },
    'yasirbroast': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'abd9c525-9845-4403-9dba-d525c140f2fe',
    },
    'nazarjan': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'f222dcbc-db96-46c7-8121-da482bad4259',
    },
    'kaybees': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'fc742556-ad1f-4cc0-99d2-2538794cb362',
    },
    'kababjees': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'b8a85d79-c8e9-4aa5-9dc7-a895ef674f5b',
    },
    'pakmedico': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': 'a44c04ef-e3d8-4ea0-8615-f157f2f06771',
    },
    'bcm': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '45166c70-65c1-4006-ad70-dc6310077d90',
    },
    'deli': {
      'scheme' : 'https',
      'baseURLLocal': 'https://tsminingapi.azurewebsites.net/',
      'baseHost': 'tsminingapi.azurewebsites.net',
      'baseHostPort': null,
      'TSAuthSign': '41051567-f0cc-4b06-ad21-485e3b3dccdf',
      
    },

  };
}
