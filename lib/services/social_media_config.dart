// Social Media API Configuration
class SocialMediaConfig {
  // Telegram Bot API
  // To create a bot:
  // 1. Open Telegram and search for @BotFather
  // 2. Send /newbot command
  // 3. Follow instructions to get your bot token
  // 4. Replace the token below
  static const String telegramBotToken = 'YOUR_TELEGRAM_BOT_TOKEN_HERE';
  // Example: '1234567890:ABCdefGHIjklMNOpqrsTUVwxyz'
  
  // Messenger (Facebook) - Requires Facebook Developer Account
  // https://developers.facebook.com/docs/messenger-platform
  static const String messengerPageAccessToken = 'YOUR_MESSENGER_PAGE_ACCESS_TOKEN';
  static const String messengerVerifyToken = 'YOUR_MESSENGER_VERIFY_TOKEN';
  
  // Viber Bot API
  // https://developers.viber.com/docs/api/rest-bot-api/
  static const String viberAuthToken = 'YOUR_VIBER_AUTH_TOKEN';
  
  // Instagram (Meta) - Uses Facebook Graph API
  // https://developers.facebook.com/docs/instagram-api
  static const String instagramAccessToken = 'YOUR_INSTAGRAM_ACCESS_TOKEN';
  
  // WhatsApp Business API (Optional)
  // https://developers.facebook.com/docs/whatsapp
  static const String whatsappToken = 'YOUR_WHATSAPP_TOKEN';
  static const String whatsappPhoneNumberId = 'YOUR_PHONE_NUMBER_ID';
}
