@{
    RootModule = '.\powershell-google-tts.psm1';
    ModuleVersion = '1.0.2';
    GUID = '2f2286d7-ef6c-4bc8-9a64-03bb81ae9af5';
    Author = 'Jared Beach';
    CompanyName = 'Unknown';
    Copyright = 'None';
    Description = 'Synethesize / play audio using Google text to speech';
    FunctionsToExport = @('*');
    CmdletsToExport = @();
    VariablesToExport = '*';
    AliasesToExport = @();
    FileList = @(
        '.\powershell-google-tts.psm1'
    );
    PrivateData = @{
        PSData = @{
            Tags = @('google', 'tts', 'speech');
            ProjectUri = 'https://github.com/jmbeach/powershell-google-tts';
        }
    }
}