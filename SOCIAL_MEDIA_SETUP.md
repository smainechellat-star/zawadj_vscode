# Social Media OTP Integration Guide

## 📱 Supported Platforms

1. **Telegram** ✈️ - Bot API (Easiest)
2. **Messenger** 💬 - Facebook Platform
3. **Viber** 📞 - REST Bot API  
4. **Instagram** 📷 - Instagram Graph API

---

## 🚀 Quick Setup for Each Platform

### 1. TELEGRAM (Recommended - Easiest)

**Step 1: Create a Bot**
1. Open Telegram app
2. Search for `@BotFather`
3. Send `/newbot` command
4. Follow instructions:
   - Choose bot name (e.g., "ZAWADJ Verification")
   - Choose username (e.g., "zawadj_verify_bot")
5. You'll receive a **Bot Token** like: `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`

**Step 2: Configure in App**
1. Open `lib/services/social_media_config.dart`
2. Replace:
   ```dart
   static const String telegramBotToken = '1234567890:ABCdefGHIjklMNOpqrsTUVwxyz';
   ```

**Step 3: Get User Chat ID**
- Users must start a conversation with your bot first
- They send `/start` to your bot
- Use this API to get updates: `https://api.telegram.org/bot<TOKEN>/getUpdates`
- Get `chat.id` from response

**Step 4: Send OTP**
Code already implemented! Just configure the token.

---

### 2. MESSENGER (Facebook)

**Step 1: Create Facebook Page**
1. Go to [Facebook Pages](https://www.facebook.com/pages/create)
2. Create a page for your app

**Step 2: Create Facebook App**
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Click "My Apps" → "Create App"
3. Select "Business" type
4. Add "Messenger" product

**Step 3: Get Page Access Token**
1. In app dashboard → Messenger → Settings
2. Add your Facebook Page
3. Generate Page Access Token
4. Copy the token

**Step 4: Configure in App**
1. Open `lib/services/social_media_config.dart`
2. Replace:
   ```dart
   static const String messengerPageAccessToken = 'YOUR_TOKEN_HERE';
   ```

**Step 5: Get User PSID (Page-Scoped ID)**
- Users must send a message to your page first
- Use webhook to capture PSID
- Store mapping: phone_number → psid

---

### 3. VIBER

**Step 1: Create Viber Bot**
1. Go to [Viber Admin Panel](https://partners.viber.com/)
2. Create account
3. Create bot
4. Get Authentication Token

**Step 2: Configure in App**
1. Open `lib/services/social_media_config.dart`
2. Replace:
   ```dart
   static const String viberAuthToken = 'YOUR_VIBER_TOKEN';
   ```

**Step 3: Send Messages**
Code already implemented! The API endpoint is:
```
POST https://chatapi.viber.com/pa/send_message
Header: X-Viber-Auth-Token: YOUR_TOKEN
```

---

### 4. INSTAGRAM

**Step 1: Instagram Business Account**
1. Convert your Instagram to Business Account
2. Connect to Facebook Page

**Step 2: Create Facebook App**
1. Same as Messenger setup
2. Add "Instagram" product
3. Get Instagram Business Account ID

**Step 3: Get Access Token**
1. Instagram Graph API requires Facebook App
2. Generate User Access Token
3. Exchange for Long-Lived Token

**Step 4: Configure in App**
1. Open `lib/services/social_media_config.dart`
2. Replace:
   ```dart
   static const String instagramAccessToken = 'YOUR_ACCESS_TOKEN';
   ```

---

## 🔧 Current Implementation Status

### ✅ Ready (Need Configuration Only)
- **Telegram**: Full API integration - just add bot token
- **Viber**: Full API integration - just add auth token

### ⚠️ Needs User Mapping
- **Messenger**: Need to map phone → PSID
- **Instagram**: Need to map phone → Instagram user ID

### 📝 What Works Now
All platforms show OTP in toast for testing. Once you configure tokens, they will send real messages.

---

## 🧪 Testing Guide

### Test Mode (Current)
1. Select any social media platform
2. Enter phone number
3. **OTP appears in toast message**
4. Copy and enter OTP

### Production Mode (After Configuration)
1. Configure platform tokens in `social_media_config.dart`
2. Users must connect their account first:
   - **Telegram**: Send `/start` to your bot
   - **Messenger**: Send message to your page
   - **Viber**: Subscribe to your bot
   - **Instagram**: Follow your business account
3. App sends OTP via platform API
4. User receives message in platform app
5. User enters OTP in your app

---

## 📋 Priority Recommendation

**Easiest to Implement:**
1. ✅ **Telegram** - Just get bot token from BotFather (5 minutes)
2. ✅ **Viber** - Create bot and get token (10 minutes)
3. ⚠️ **Messenger** - Requires Facebook app setup (30 minutes)
4. ⚠️ **Instagram** - Complex, needs Facebook Graph API (1 hour)

**Recommended Approach:**
1. Start with **Telegram** - easiest and most popular
2. Add **Viber** - also simple
3. Add **Messenger** if needed for Facebook users
4. Add **Instagram** last - most complex

---

## 🔐 Security Best Practices

1. **Never commit tokens to git**
   - Use environment variables
   - Or Firebase Remote Config
   
2. **Implement rate limiting**
   - Limit OTP requests per phone number
   - Add cooldown between requests

3. **OTP expiration**
   - Currently stored in memory
   - Add timestamp and expiration check

4. **User verification**
   - Verify users own the social media account
   - Match phone number with account

---

## 📞 Integration Example: Telegram

Want to test Telegram right now? Follow these 5 steps:

1. **Open Telegram** → Search `@BotFather`

2. **Create bot**:
   ```
   /newbot
   Bot name: ZAWADJ Verification Bot
   Username: zawadj_verify_bot
   ```

3. **Copy token** (looks like: `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`)

4. **Edit config file**:
   ```dart
   // lib/services/social_media_config.dart
   static const String telegramBotToken = '123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11';
   ```

5. **Users must start bot first**:
   - User opens Telegram
   - Searches for your bot: `@zawadj_verify_bot`
   - Clicks "Start"
   - Now they can receive OTP!

---

## 🆘 Troubleshooting

### "Token not configured" message?
→ Edit `lib/services/social_media_config.dart` with your tokens

### "User must start chat with bot"?
→ User needs to open the platform app and connect with your bot/page first

### OTP not sending?
→ Check logs in terminal for API errors
→ Verify token is correct
→ Check internet connection

### Want to use SMS only?
→ Just select "SMS" chip - Firebase Phone Auth is already configured!

---

## 📚 Official Documentation Links

- **Telegram Bot API**: https://core.telegram.org/bots/api
- **Messenger Platform**: https://developers.facebook.com/docs/messenger-platform
- **Viber REST API**: https://developers.viber.com/docs/api/rest-bot-api/
- **Instagram Graph API**: https://developers.facebook.com/docs/instagram-api

---

## ✨ Next Steps

1. Choose your platform (Telegram recommended)
2. Get API token/credentials
3. Update `social_media_config.dart`
4. Rebuild app
5. Test with real account!

Need help with specific platform? Let me know which one!
