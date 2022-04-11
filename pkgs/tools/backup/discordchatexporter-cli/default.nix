{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, testVersion
, discordchatexporter-cli
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.34";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    sha256 = "EHpnLUFHR+FC1qlwW0TuLas9aA/CMELHkzbLlNyiwgE=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  nugetDeps = ./deps.nix;

  postFixup = ''
    ln -s $out/bin/DiscordChatExporter.Cli $out/bin/discordchatexporter-cli
  '';

  passthru = {
    updateScript = ./updater.sh;
    tests.version = testVersion {
      package = discordchatexporter-cli;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "A tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/blob/${version}/Changelog.md";
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}
