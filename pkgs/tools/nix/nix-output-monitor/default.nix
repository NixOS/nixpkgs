{ mkDerivation, ansi-terminal, async, attoparsec, base, containers
, directory, HUnit, mtl, nix-derivation, process, relude, stdenv
, stm, text, time, unix, fetchFromGitHub
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "0.1.0.2";
  src = fetchFromGitHub {
    owner = "maralorn";
    repo = "nix-output-monitor";
    sha256 = "0r4348cbmnpawbfa20qw3wnywiqp0jkl5svzl27jrm2yk2g51509";
    rev = "5bf7534";
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
