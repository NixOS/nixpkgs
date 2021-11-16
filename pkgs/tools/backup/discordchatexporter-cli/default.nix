{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.30.1";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    sha256 = "JSYIhd+DNVOKseHtWNNChECR5hKr+ntu1Yyqtnlg8rM=";
  };

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  dotnet-runtime = dotnetCorePackages.runtime_3_1;
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  meta = with lib; {
    description = "A tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
  passthru.updateScript = ./updater.sh;
}
