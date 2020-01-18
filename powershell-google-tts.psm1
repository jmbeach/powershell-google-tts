$baseUrl = 'https://texttospeech.googleapis.com/v1/';

# requires ffplay (can be installed from ffmpeg)
function Start-GoogleTTS ($text) {
    $data = [psobject]::new()
    $audioConfig = [psobject]::new();
    $audioConfig | Add-Member -NotePropertyName 'audioEncoding' -NotePropertyValue 'MP3';
    $input = [psobject]::new();
    $input | Add-Member -NotePropertyName 'text' -NotePropertyValue $text;
    $voice = [psobject]::new();
    $voice | Add-Member -NotePropertyName 'languageCode' -NotePropertyValue 'en-US';
    $voice | Add-Member -NotePropertyName 'name' -NotePropertyValue 'en-US-Standard-C';
    $data | Add-Member -NotePropertyName 'audioConfig' -NotePropertyValue $audioConfig;
    $data | Add-Member -NotePropertyName 'input' -NotePropertyValue $input;
    $data | Add-Member -NotePropertyName 'voice' -NotePropertyValue $voice;
    $response = Invoke-WebRequest -Uri ($baseUrl + 'text:synthesize?key=' + $env:GOOGLE_API_KEY_TTS) -ContentType 'application/json' -Body (ConvertTo-Json $data) -Method POST
    $audioData = $response.Content | ConvertFrom-Json;
    $base64 = [System.Convert]::FromBase64String($audioData.audioContent);
    $tmpFile = $env:TEMP + "\" + [System.DateTime]::Now.ToSTring('yyyy-MM-dd-hh-mm-ss-ff') + '.mp3';
    [System.IO.File]::WriteAllBytes($tmpFile, $base64);
    ffplay.exe -nodisp -autoexit -hide_banner -loglevel panic $tmpFile > $null
    Remove-Item $tmpFile -Force
}