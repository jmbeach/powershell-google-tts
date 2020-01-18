# Powershell Google TTS

This powershell module synthesizes speech from text in Powershell using [Google's Text-to-Speech API](https://cloud.google.com/text-to-speech/)

To use this module, install it from the [Powershell Gallery](https://www.powershellgallery.com/packages/powershell-google-tts);

```
Install-Module -Name powershell-google-tts
```

Add an environment variable `GOOGLE_API_KEY_TTS` and set the value to a valid API key.

Then, in Powershell, run `Start-GoogleTTS 'your text here'`