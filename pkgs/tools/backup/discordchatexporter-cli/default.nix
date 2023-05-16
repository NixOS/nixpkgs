{ lib
, buildDotnetModule
<<<<<<< HEAD
, dotnetCorePackages
, fetchFromGitHub
=======
, fetchFromGitHub
, dotnetCorePackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, testers
, discordchatexporter-cli
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
<<<<<<< HEAD
  version = "2.40.4";
=======
  version = "2.36.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-XmUTGVOU67fSX0mZg2f5j8pb6ID7amzJpD4F7u6f3GM=";
=======
    sha256 = "svBVXny8ZsZnXG5cDPDKlR2dNhPzPOW4VGaOZkLrRNA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  nugetDeps = ./deps.nix;
<<<<<<< HEAD
  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ eclairevoyant ivar ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "discordchatexporter-cli";
=======
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
