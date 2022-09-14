{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, ncurses
}:

buildDotnetModule rec {
  pname = "birdsitelive";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "NicolasConstant";
    repo = "BirdsiteLive";
    rev = version;
    hash = "sha256-akTFgLycUzUgTBlL37ZJoqllr0oO3/rA1G1u1OI5s/I=";
  };

  runtimeDeps = [ ncurses ];

  projectFile = [
    "src/BirdsiteLive/BirdsiteLive.csproj"
    "src/BSLManager/BSLManager.csproj"
  ];

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.aspnetcore_3_1;

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/NicolasConstant/BirdsiteLive";
    description = "Twitter to ActivityPub bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mvs ];
  };
}
