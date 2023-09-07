{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnet-sdk
, dotnetCorePackages
, gtk3
, libnotify
, makeDesktopItem
, glibc
}:

buildDotnetModule rec {
  pname = "frankendrift";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "awlck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WiBSc09atlwywDIEw9LYHr6P0qi1EqMCMi2UqQDl7Ys=";
  };

  projectFile = "FrankenDrift.Runner/FrankenDrift.Runner.Gtk/FrankenDrift.Runner.Gtk.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  dotnetFlags = [
    "-p:Configuration=Release"
    "-p:Version=0.6.1"
  ];
  runtimeDeps = [
    gtk3
    libnotify
  ];
  executables = [ "FrankenDrift.Runner.Gtk" ];

  postFixup = ''
    mv $out/bin/FrankenDrift.Runner.Gtk $out/bin/frankendrift
  '';
  nugetDeps = ./deps.nix;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = pname;
      desktopName = "FrankenDrift";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = meta.mainProgram;
    })
  ];


  meta = with lib.licenses; {
    homepage = "https://github.com/awlck/frankendrift";
    description = "Cross-platform frontend for the ADRIFT Runner";
    license = [ mit bsd3 ];
    maintainers = with lib.maintainers; [ agentx3 ];
    mainProgram = "FrankenDrift.Runner.Gtk";
  };
}
