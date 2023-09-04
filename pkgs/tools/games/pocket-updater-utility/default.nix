{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, buildDotnetModule ? pkgs.buildDotnetModule
, dotnetCorePackages ? pkgs.dotnetCorePackages
, openssl ? pkgs.openssl
, zlib ? pkgs.zlib
, targetPlatform ? pkgs.targetPlatform
}:

buildDotnetModule rec {
  pname = "pocket-updater-utility";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "mattpannella";
    repo = "${pname}";
    rev = "${version}";
    hash = "sha256-z90YITAW2Nv+Mq2q56As4PoHqGPEnvDUPH73bhz/xnw=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  # See https://github.com/NixOS/nixpkgs/pull/196648/commits/0fb17c04fe34ac45247d35a1e4e0521652d9c494
  patches = [ ./add-runtime-identifier.patch ];
  postPatch = ''
    substituteInPlace pocket_updater.csproj \
      --replace @RuntimeIdentifier@ "${dotnetCorePackages.systemToDotnetRid targetPlatform.system}"
  '';

  projectFile = "pocket_updater.csproj";

  nugetDeps = ./deps.nix;

  selfContainedBuild = true;

  executables = [ "pocket_updater" ];

  dotnetFlags = [
    "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  meta = with lib; {
    homepage = "https://github.com/mattpannella/pocket-updater-utility";
    description = "Analogue Pocket Updater Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ p-rintz ];
    mainProgram = "pocket_updater";
  };
}
