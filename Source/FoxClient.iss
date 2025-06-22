#define MyAppName "FoxClient"
#define MyAppVersion "1.21"
#define MyAppPublisher "Zipp"
#define MyAppURL "discord.gg/crystalcommunity"
#define MyAppExeName "MyProg-x64.exe"

[Setup]
AppId={{4A5A855E-CBF6-4144-BD15-EDD79D47A11F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
LicenseFile=**REPLACE**\FoxClient\License.txt
PrivilegesRequired=admin
OutputDir=**REPLACE**\FoxClient
OutputBaseFilename=mysetup
SetupIconFile=**REPLACE**\FoxClient\icon.ico
UninstallDisplayIcon=**REPLACE**\FoxClient\icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
WizardImageFile=**REPLACE**\FoxClient\installer-side.bmp
WizardSmallImageFile=**REPLACE**\FoxClient\installer-top.bmp

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
Source: "**REPLACE**\FoxClient\FoxClient\*"; DestDir: "{userappdata}\.minecraft\versions\FoxClient"; Flags: recursesubdirs createallsubdirs
Source: "**REPLACE**\FoxClient\launcher_profiles.template.json"; DestDir: "{tmp}"; Flags: dontcopy
Source: "**REPLACE**\FoxClient\installer-side.bmp"; Flags: dontcopy
Source: "**REPLACE**\FoxClient\installer-top.bmp"; Flags: dontcopy

[Code]
var
  LaunchMinecraftCheckbox: TNewCheckbox;
procedure InitializeWizard();
var
  ResultCode: Integer;
begin
  Exec('taskkill', '/IM MinecraftLauncher.exe /F', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
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
  end;
end;
procedure CurStepChanged(CurStep: TSetupStep);
var
  SourceFile, TargetFile, GameDir, TemplateFile, LauncherFile, MinecraftDir: string;
  GameDirForwardSlash: string;
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    MinecraftDir := ExpandConstant('{userappdata}\.minecraft');
    GameDir := MinecraftDir + '\versions\FoxClient';
    if not DirExists(GameDir) then
      ForceDirectories(GameDir);
    SourceFile := MinecraftDir + '\options.txt';
    TargetFile := GameDir + '\options.txt';
    if FileExists(SourceFile) then
      FileCopy(SourceFile, TargetFile, False);
    TemplateFile := ExpandConstant('{tmp}\launcher_profiles.template.json');
    LauncherFile := MinecraftDir + '\launcher_profiles.json';
    ExtractTemporaryFile('launcher_profiles.template.json');
    GameDirForwardSlash := GameDir;
    StringChangeEx(GameDirForwardSlash, '\', '/', True);
    ReplaceTextInFile(TemplateFile, LauncherFile, '{GAMEDIR}', GameDirForwardSlash);
    if not FileExists(LauncherFile) then
      MsgBox('Warning: Could not create launcher_profiles.json', mbError, MB_OK);
  end;
end;
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
    LaunchMinecraftCheckbox.Visible := True;
end;
function InitializeSetup(): Boolean;
begin
  Result := True;
end;
procedure DeinitializeSetup();
var
  LauncherPath, TLauncherPath: string;
  ResultCode: Integer;
begin
  if LaunchMinecraftCheckbox.Checked then
  begin
    LauncherPath := ExpandConstant('{pf}\Minecraft Launcher\MinecraftLauncher.exe');
    if FileExists(LauncherPath) then
    begin
      Exec(LauncherPath, '', '', SW_SHOWNORMAL, ewNoWait, ResultCode);
    end
    else
    begin
      if Exec('cmd.exe', '/C start "" "shell:AppsFolder\Microsoft.4297127D64EC6_8wekyb3d8bbwe!Minecraft"', '', SW_HIDE, ewNoWait, ResultCode) then
      begin
      end
      else
      begin
        TLauncherPath := ExpandConstant('{userappdata}\.minecraft\TLauncher.exe');
        if FileExists(TLauncherPath) then
        begin
          Exec(TLauncherPath, '', '', SW_SHOWNORMAL, ewNoWait, ResultCode);
        end
      end;
    end;
  end;
end;

[Icons]
Name: "{userprograms}\FoxClient Local Files"; \
  Filename: "{userappdata}\.minecraft\versions\FoxClient"; \
  IconFilename: "**REPLACE**\FoxClient\icon.ico"; \
  IconIndex: 0
Name: "{userappdata}\.minecraft\.FoxClient Local Files"; \
  Filename: "{userappdata}\.minecraft\versions\FoxClient"; \
  IconFilename: "**REPLACE**\FoxClient\icon.ico"; \
  IconIndex: 0

