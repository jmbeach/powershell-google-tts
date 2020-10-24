# Powershell Google TTS

This powershell module synthesizes speech from text in Powershell using [Google's Text-to-Speech API](https://cloud.google.com/text-to-speech/)

To use this module, install it from the [Powershell Gallery](https://www.powershellgallery.com/packages/powershell-google-tts)

```
Install-Module -Name powershell-google-tts
```

Add an environment variable `GOOGLE_API_KEY_TTS` and set the value to a valid API key.

Then, in Powershell, run `Start-GoogleTTS 'your text here'`.

If the text exceeds Google's maximum input, it automatically splits up the text into multiple requests and concatenates the audio output.

# Usage

```powershell
Start-GoogleTTS
  [-text] <string>      # The text to speak
  [-speed] <number>     # Optional speed of the speech (defaults to 1)
  [-outFile] <string>   # Optional path to save mp3 file of the TTS audio
  [-voiceName] <string> # Optional voice name - autocompletes (defaults to en-US-Standard-C)
```

# Examples

## Speak Text From File

```
Start-GoogleTTS $(cat ./example.txt | Out-String)
```