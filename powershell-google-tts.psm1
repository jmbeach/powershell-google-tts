$baseUrl = 'https://texttospeech.googleapis.com/v1/';

function Get-GoogleTTSVoices() {
  return Invoke-WebRequest -Uri ($baseUrl + 'voices?key=' + $env:GOOGLE_API_KEY_TTS) -ContentType 'application/json' -Method GET | ConvertFrom-Json;
}

$completer = {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $upper = $wordToComplete.ToUpper()
  (Get-GoogleTTSVoices).voices.name | Where-Object {
      $_.ToUpper() -like "$upper*"
  } | ForEach-Object {
      $_;
  }
}

# requires ffplay (can be installed from ffmpeg)
function Start-GoogleTTS ($text, $speed, $outFile, $voiceName) {
    $text = $text.Replace('“', "").Replace('”', "");
    $data = [psobject]::new()
    $audioConfig = [psobject]::new();
    $audioConfig | Add-Member -NotePropertyName 'audioEncoding' -NotePropertyValue 'MP3';
    if ($null -ne $speed) {
        $audioConfig | Add-Member -NotePropertyName 'speakingRate' -NotePropertyValue $speed
    }

    if ($null -eq $voiceName) {
        $voiceName = 'en-US-Standard-C';
    }

    $i = 0;
    $j = 0;
    $parts = $text.Split(' ');
    $outFiles = [System.Collections.Generic.List[string]]::new();
    $useTemp = $null -eq $outFile;
    $input = [psobject]::new();
    $input | Add-Member -NotePropertyName 'text' -NotePropertyValue $null;
    $voice = [psobject]::new();
    $voice | Add-Member -NotePropertyName 'languageCode' -NotePropertyValue 'en-US';
    $voice | Add-Member -NotePropertyName 'name' -NotePropertyValue $voiceName;
    $data | Add-Member -NotePropertyName 'audioConfig' -NotePropertyValue $audioConfig;
    $data | Add-Member -NotePropertyName 'input' -NotePropertyValue $input;
    $data | Add-Member -NotePropertyName 'voice' -NotePropertyValue $voice;
    while ($i -lt $text.Length / 5000) {
        $chunk = '';
        while ($j -lt $parts.Length -and ($chunk.Length + $parts[$j].Length + 1) -lt 5000) {
            $chunk += $parts[$j] + ' ';
            $j++;
        }

        $input.text = $chunk;
        $response = Invoke-WebRequest -Uri ($baseUrl + 'text:synthesize?key=' + $env:GOOGLE_API_KEY_TTS) -ContentType 'application/json' -Body (ConvertTo-Json $data) -Method POST;
        $audioData = $response.Content | ConvertFrom-Json;
        $base64 = [System.Convert]::FromBase64String($audioData.audioContent);
        $tempPath = $env:TEMP;
        if ($null -eq $tempPath) {
          $tempPath = "/tmp";
        }

        $tmpFile = "$tempPath/$([System.DateTime]::Now.ToSTring('yyyy-MM-dd-hh-mm-ss-ff')).mp3";
        $writeFile = "$outFile.$i";
        if ($useTemp) {
            $writeFile = $tmpFile;
        }

        [System.IO.File]::WriteAllBytes($writeFile, $base64);
        if ($useTemp) {
            ffplay -nodisp -autoexit -hide_banner -loglevel panic $writeFile > $null;
            Remove-Item $writeFile -Force;
        }
        else {
            # add it to file for concatenation
            $outFiles.Add($writeFile);
            "file '$writeFile'" | Out-File 'concat.txt' -Append -Encoding ascii;
        }

        $i++;
    }

    if (-not $useTemp) {
        ffmpeg -f concat -safe 0 -i concat.txt -c copy $outFile
        $outFiles | ForEach-Object {
            Remove-Item $_ -Force
        }

        Remove-Item concat.txt -Force
    }
}

Register-ArgumentCompleter -CommandName Start-GoogleTTS -ParameterName voiceName -ScriptBlock $completer;