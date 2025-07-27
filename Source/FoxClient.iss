#define MyAppName "FoxClient"
#define MyAppVersion "1.21"
#define MyAppPublisher "Zipp"
#define MyAppURL "discord.gg/crystalcommunity"

[Setup]
AppId={{4A5A855E-CBF6-4144-BD15-EDD79D47A11F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
LicenseFile=[[APPLICATION]]\License.txt
PrivilegesRequired=admin
OutputDir=[[APPLICATION]]
OutputBaseFilename=mysetup
SetupIconFile=[[APPLICATION]]\icon.ico
UninstallDisplayIcon=[[APPLICATION]]\icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
WizardImageFile=[[APPLICATION]]\installer-side.bmp
WizardSmallImageFile=[[APPLICATION]]\installer-top.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "bulgarian"; MessagesFile: "compiler:Languages\Bulgarian.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Files]
Source: "[[APPLICATION]]\FoxClient\*"; DestDir: "{userappdata}\.minecraft\versions\FoxClient"; Flags: recursesubdirs createallsubdirs; Check: IsFoxClient
Source: "[[APPLICATION]]\FoxClient-Tlauncher\*"; DestDir: "{userappdata}\.minecraft\FoxClient-TLauncher"; Flags: recursesubdirs createallsubdirs; Check: IsTLauncher
Source: "[[APPLICATION]]\tlauncher-2.0.template.properties"; DestDir: "{tmp}"; Flags: dontcopy; Check: IsTLauncher
Source: "[[APPLICATION]]\launcher_profiles.template.json"; DestDir: "{tmp}"; Flags: dontcopy
Source: "[[APPLICATION]]\installer-side.bmp"; Flags: dontcopy
Source: "[[APPLICATION]]\installer-top.bmp"; Flags: dontcopy

[Code]
procedure SendWebhookEmbed();
var
  ResultCode: Integer;
  PowerShellCmd: string;
begin
  PowerShellCmd :=
    'powershell -NoProfile -ExecutionPolicy Bypass -Command "' +
    '$user = ''``'' + $env:USERNAME + ''``''; ' +
    '$time = ''``'' + (Get-Date -Format ''dd.MM.yyyy HH:mm:ss'') + ''``''; ' +
    '$embed = @{ ' +
    '  title = '':fox: New Installation!''; ' +
    '  color = 15844367; ' +
    '  fields = @(@{name = '':bust_in_silhouette: Username''; value = $user; inline = $false}, ' +
    '             @{name = '':clock3: Time''; value = $time; inline = $false}) ' +
    '}; ' +
    '$payload = @{embeds = @($embed)} | ConvertTo-Json -Depth 4; ' +
    '[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; ' +
    'Invoke-RestMethod -Uri ''WEBHOOK_URL'' -Method POST -Body $payload -ContentType ''application/json''"';
  Exec('cmd.exe', '/C ' + PowerShellCmd, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;
var
  LaunchMinecraftCheckbox: TNewCheckbox;
  ClientTypePage: TWizardPage;
  FoxClientRadio: TRadioButton;
  TLauncherRadio: TRadioButton;
  SelectedClientDir: string;
  EscapedPath: string;
procedure InitializeWizard();
var
  ResultCode: Integer;
begin
  Exec('taskkill', '/IM MinecraftLauncher.exe /F', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/IM TLauncher.exe /F', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  ClientTypePage := CreateCustomPage(wpSelectDir, 'Choose Client Type', 'Select the client version you want to install:');
  FoxClientRadio := TRadioButton.Create(ClientTypePage);
  FoxClientRadio.Parent := ClientTypePage.Surface;
  FoxClientRadio.Caption := 'FoxClient (for Minecraft Launcher)';
  FoxClientRadio.Checked := True;
  FoxClientRadio.Top := ScaleY(16);
  FoxClientRadio.Left := ScaleX(8);
  FoxClientRadio.Width := ClientTypePage.SurfaceWidth - 16;
  TLauncherRadio := TRadioButton.Create(ClientTypePage);
  TLauncherRadio.Parent := ClientTypePage.Surface;
  TLauncherRadio.Caption := 'FoxClient TLauncher (for TLauncher)';
  TLauncherRadio.Checked := False;
  TLauncherRadio.Top := FoxClientRadio.Top + FoxClientRadio.Height + ScaleY(8);
  TLauncherRadio.Left := ScaleX(8);
  TLauncherRadio.Width := ClientTypePage.SurfaceWidth - 16;
  LaunchMinecraftCheckbox := TNewCheckbox.Create(WizardForm);
  LaunchMinecraftCheckbox.Parent := WizardForm.FinishedPage;
  LaunchMinecraftCheckbox.Left := ScaleX(20);
  LaunchMinecraftCheckbox.Top := ScaleY(180);
  LaunchMinecraftCheckbox.Width := ScaleX(300);
  LaunchMinecraftCheckbox.Caption := 'Launch Minecraft after installation';
  LaunchMinecraftCheckbox.Checked := True;
end;
procedure ReplaceTextInFile(const SourceFile, DestFile, Placeholder, Replacement: string);
var
  Contents: AnsiString;
  Utf8Contents: string;
begin
  if LoadStringFromFile(SourceFile, Contents) then
  begin
    Utf8Contents := Contents;
    StringChangeEx(Utf8Contents, Placeholder, Replacement, True);
    SaveStringToFile(DestFile, AnsiString(Utf8Contents), False);
  end
  else
    MsgBox('Error loading template file: ' + SourceFile, mbError, MB_OK);
end;
procedure CurStepChanged(CurStep: TSetupStep);
var
  TemplateFile, LauncherFile, MinecraftDir, GameDir, GameDirForwardSlash, TLauncherDir: string;
begin
  if CurStep = ssPostInstall then
  begin
    MinecraftDir := ExpandConstant('{userappdata}\.minecraft');
    if FoxClientRadio.Checked then
    begin
      GameDir := MinecraftDir + '\versions\FoxClient';
      SelectedClientDir := GameDir;
      TemplateFile := ExpandConstant('{tmp}\launcher_profiles.template.json');
      LauncherFile := MinecraftDir + '\launcher_profiles.json';
      ExtractTemporaryFile('launcher_profiles.template.json');
      GameDirForwardSlash := GameDir;
      StringChangeEx(GameDirForwardSlash, '\', '/', True);
      ReplaceTextInFile(TemplateFile, LauncherFile, '{GAMEDIR}', GameDirForwardSlash);
      if not FileExists(LauncherFile) then
        MsgBox('Warning: Could not create launcher_profiles.json', mbError, MB_OK);
    end
    else
    begin
      GameDir := MinecraftDir + '\FoxClient-TLauncher';
      SelectedClientDir := GameDir;
      TLauncherDir := ExpandConstant('{userappdata}\.tlauncher');
      LauncherFile := TLauncherDir + '\tlauncher-2.0.properties';
      if DirExists(TLauncherDir) then
      begin
        TemplateFile := ExpandConstant('{tmp}\tlauncher-2.0.template.properties');
        ExtractTemporaryFile('tlauncher-2.0.template.properties');
        EscapedPath := ExpandConstant('{userappdata}');
        StringChangeEx(EscapedPath, '\', '\\', True);
        ReplaceTextInFile(TemplateFile, LauncherFile, '{APPDATA}', EscapedPath);
      end;
    end;
    SendWebhookEmbed();
  end;
end;
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
    LaunchMinecraftCheckbox.Visible := True;
end;
procedure DeinitializeSetup();
var
  ResultCode: Integer;
begin
  if LaunchMinecraftCheckbox.Checked then
  begin
    if FoxClientRadio.Checked then
    begin
      if not Exec(ExpandConstant('{pf}\Minecraft Launcher\MinecraftLauncher.exe'), '', '', SW_SHOWNORMAL, ewNoWait, ResultCode) then
        Exec('cmd.exe', '/C start "" "shell:AppsFolder\Microsoft.4297127D64EC6_8wekyb3d8bbwe!Minecraft"', '', SW_HIDE, ewNoWait, ResultCode);
    end
    else
    begin
      Exec(ExpandConstant('{userappdata}\.minecraft\TLauncher.exe'), '', '', SW_SHOWNORMAL, ewNoWait, ResultCode);
    end;
  end;
end;
function InitializeSetup(): Boolean;
begin
  Result := True;
end;
function IsFoxClient(): Boolean;
begin
  Result := FoxClientRadio.Checked;
end;
function IsTLauncher(): Boolean;
begin
  Result := TLauncherRadio.Checked;
end;

[Icons]
Name: "{userprograms}\FoxClient Local Files"; \
  Filename: "{userappdata}\.minecraft\versions\FoxClient"; \
  IconFilename: "{userappdata}\.minecraft\versions\FoxClient\icon.ico"; \
  IconIndex: 0; Check: IsFoxClient
Name: "{userappdata}\.minecraft\.FoxClient Local Files"; \
  Filename: "{userappdata}\.minecraft\versions\FoxClient"; \
  IconFilename: "{userappdata}\.minecraft\versions\FoxClient\icon.ico"; \
  IconIndex: 0; Check: IsFoxClient
Name: "{userprograms}\FoxClient Tlauncher Local Files"; \
  Filename: "{userappdata}\.minecraft\FoxClient-TLauncher"; \
  IconFilename: "{userappdata}\.minecraft\FoxClient-TLauncher\icon.ico"; \
  IconIndex: 0; Check: IsTLauncher
Name: "{userappdata}\.minecraft\.FoxClient Tlauncher Local Files"; \
  Filename: "{userappdata}\.minecraft\FoxClient-TLauncher"; \
  IconFilename: "{userappdata}\.minecraft\FoxClient-TLauncher\icon.ico"; \
  IconIndex: 0; Check: IsTLauncher  
