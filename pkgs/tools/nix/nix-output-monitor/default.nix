{ mkDerivation, ansi-terminal, async, attoparsec, base, containers
, cassava, directory, HUnit, mtl, nix-derivation, process, relude, lib
, stm, terminal-size, text, time, unix, wcwidth, fetchFromGitHub
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "1.0.1.1";
  src = fetchFromGitHub {
    owner = "maralorn";
    repo = "nix-output-monitor";
    sha256 = "1wi1gsl5q1sy7k6k5wxhwpwzki7rghhbsyzm84hnw6h93w6401ax";
    rev = "v1.0.1.1";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal async attoparsec base cassava containers directory mtl
    nix-derivation relude stm terminal-size text time unix wcwidth
  ];
  executableHaskellDepends = [
    ansi-terminal async attoparsec base containers directory mtl
    nix-derivation relude stm text time unix
  ];
  testHaskellDepends = [
    ansi-terminal async attoparsec base containers directory HUnit mtl
    nix-derivation process relude stm text time unix
  ];
  homepage = "https://github.com/maralorn/nix-output-monitor";
  description = "Parses output of nix-build to show additional information";
  license = lib.licenses.agpl3Plus;
  maintainers = [ lib.maintainers.maralorn ];
}
