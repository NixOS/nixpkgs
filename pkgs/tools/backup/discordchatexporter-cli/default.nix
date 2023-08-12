{ lib
, buildDotnetModule
, fetchFromGitHub
, testers
, discordchatexporter-cli
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.36.1";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    sha256 = "svBVXny8ZsZnXG5cDPDKlR2dNhPzPOW4VGaOZkLrRNA=";
  };

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  nugetDeps = ./deps.nix;

  postFixup = ''
    ln -s $out/bin/DiscordChatExporter.Cli $out/bin/discordchatexporter-cli
  '';

  passthru = {
    updateScript = ./updater.sh;
    tests.version = testers.testVersion {
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
