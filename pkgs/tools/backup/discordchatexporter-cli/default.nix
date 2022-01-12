{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.31.1";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    sha256 = "QK63H+Qyd8zEue84vECcyAP6FH8az++1PZmbrPvBgrU=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
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
