// Constants for dropdown lists and system data

class AppConstants {
  // Algerian Cities (States/Wilayat)
  static const List<String> algerianCities = [
    'Adrar',
    'Chlef',
    'Laghouat',
    'Oum El Bouaghi',
    'Batna',
    'Béjaïa',
    'Biskra',
    'Béchar',
    'Blida',
    'Bouïra',
    'Tamanrasset',
    'Tébessa',
    'Tlemcen',
    'Tiaret',
    'Tizi Ouzou',
    'Algiers',
    'Djelfa',
    'Jijel',
    'Sétif',
    'Saïda',
    'Skikda',
    'Sidi Bel Abbès',
    'Annaba',
    'Guelma',
    'Constantine',
    'Médéa',
    'Mostaganem',
    'M\'sila',
    'Mascara',
    'Ouargla',
    'Oran',
    'El Bayadh',
    'Illizi',
    'Bordj Baji Mokhtar',
    'El Tarf',
    'Tindouf',
    'Touggourt',
    'Ghardaia',
    'Relizane',
    'Aïn Defla',
    'Aïn Témouchent',
    'Tipasa',
    'Mila',
    'Sahrawi Arab Democratic Republic',
    'Khenchela',
    'Souk Ahras',
    'Tamanrasset (Revised)',
    'Tissemassilt',
    'El M\'ghair',
    'El Menia',
    'Ouled Djellal',
    'Bordj El Kiffan',
    'Drean',
  ];

  // Age Range
  static const List<int> ageRange = [
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    98,
    99,
    100,
  ];

  // Height Range in cm
  static final List<int> heightRange = List.generate(
    101,
    (i) => 100 + i,
  ); // 100-200

  // Common Countries (Sample - could be extended)
  static const List<String> countries = [
    'Algeria',
    'Afghanistan',
    'Albania',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Cape Verde',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hong Kong',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Ivory Coast',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macao',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Republic of the Congo',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'The Gambia',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  // Number of children
  static const List<int> numberOfChildren = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Serious process duration options (in days)
  static const int seriousProcessDays = 30; // Maximum duration
  static const int chatInitialAllowedDays =
      3; // Before contact info can be shared

  // Statistics
  static const int totalRegisteredUsers = 0;
  static const int availableUsers = 0;
  static const int seriousProcessUsers = 0;
  static const int marriedUsers = 0;
  static const int withdrawnUsers = 0;
}

// Terms and Conditions Text
const String termsAndConditionsAr = '''
باستخدامك لهذا التطبيق، فإنك تقرّ وتوافق على ما يلي:

• الغرض من التطبيق هو الزواج الشرعي فقط.
• يمنع استخدام التطبيق لأي علاقة خارج إطار الزواج.
• يمنع إرسال أرقام الهواتف أو روابط التواصل قبل فتح التواصل الرسمي.
• جميع المعلومات المقدمة صحيحة وعلى مسؤولية المستخدم.
• يحق لإدارة التطبيق تعليق أو حذف أي حساب مخالف دون إشعار مسبق.

شروط أخلاقية وتعهد:
• أتعهد بالجدية
• أتعهد بعدم إساءة الاستخدام
• أتعهد أن البيانات صحيحة
• أتعهد بإخبار الطرف الآخر بأي حالة مرضية معدية أو مزمنة قد تؤثر على الحياة الزوجية قبل إتمام أي خطوة رسمية.
''';

const String termsAndConditionsEn = '''
By using this application, you agree to the following:

• The purpose of the application is lawful marriage only.
• The application is prohibited from being used for any relationship outside the framework of marriage.
• It is forbidden to send phone numbers or contact links before opening official communication.
• All information provided is accurate and the user is responsible for it.
• The application administration has the right to suspend or delete any non-compliant account without prior notice.

Ethical Conditions and Commitment:
• I commit to seriousness
• I commit to not misusing the application
• I commit to the accuracy of the data
• I undertake to inform the other party of any contagious or chronic condition that may affect married life before taking any formal step.
''';

// Welcome Message
const String welcomeMessageAr = '''
مرحًا بك في تطبيق زواج ZAWADJ

أيقونة: علم الجزائر داخل إطار على شكل قلب

هذا التطبيق مخصص لمن أراد إكمال نصف دينه.
التفكير في الزواج لا يخضع للمعادلات الرياضية.
زواج ليلة تدبيره عام.
دير النية وبات برا في الطريق
فاذا عزمت فتوكل على الله.
''';

const String welcomeMessageEn = '''
Welcome to ZAWADJ Marriage Application

Icon: Flag of Algeria inside a heart-shaped frame

This application is intended for those who want to complete half of their faith.
Thinking about marriage is not subject to mathematical equations.
A marriage whose night plan is wise.
Set your intention and be on the road.
So if you are determined, rely on Allah.
''';

// About App Text
const String aboutAppAr = '''
تم تطوير هذا التطبيق بهدف تسهيل التعارف الجاد

مالك ومشرف التطبيق
الاسم واللقب: سماعين شلاط

تم تصميم هذا التطبيق خصيصًا لأجهزة الأندرويد. إصدار 2026

لا تنسونا من صالح دعائكم
''';

const String aboutAppEn = '''
This application has been developed to facilitate serious networking.

Application Owner and Administrator
Name and Title: Smaine Chellat

This application was designed specifically for Android devices. Version 2026

Do not forget us in your kind prayers
''';

const String contactEmail = 'smaine.chellat@gmail.com';
