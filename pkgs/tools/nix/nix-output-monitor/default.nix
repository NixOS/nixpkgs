{ mkDerivation, ansi-terminal, async, attoparsec, base, containers
, directory, HUnit, mtl, nix-derivation, process, relude, stdenv
, stm, text, time, unix, fetchFromGitHub
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "0.1.0.0";
  src = fetchFromGitHub {
    owner = "maralorn";
    repo = "nix-output-monitor";
    sha256 = "1k9fni02y7xb97mkif1k7s0y1xv06hnqbkds35k4gg8mnf5z911i";
    rev = "a0e0b09";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal async attoparsec base containers directory mtl
    nix-derivation relude stm text time unix
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
  license = stdenv.lib.licenses.agpl3Plus;
  maintainers = [ stdenv.lib.maintainers.maralorn ];
}
