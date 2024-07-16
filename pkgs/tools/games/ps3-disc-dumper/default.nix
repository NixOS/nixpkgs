{ lib
, buildDotnetModule
, fetchFromGitHub
, zlib
, openssl
}:

buildDotnetModule rec {
  pname = "ps3-disc-dumper";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "13xforever";
    repo = "ps3-disc-dumper";
    rev = "v${version}";
    sha256 = "sha256-m3TS9H6cbEAHn6PvYQDMzdKdnOnDSM4lxCTdHBCXLV4=";
  };

  selfContainedBuild = true;

  projectFile = "UI.Console/UI.Console.csproj";
  nugetDeps = ./deps.nix;

  runtimeDeps = [
    zlib
    openssl
  ];

  meta = with lib; {
    homepage = "https://github.com/13xforever/ps3-disc-dumper";
    description = "Handy utility to make decrypted PS3 disc dumps";
    license = licenses.mit;
    maintainers = with maintainers; [ evanjs ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ps3-disc-dumper";
  };
}
