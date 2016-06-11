{ mkDerivation, aeson, base, bytestring, Cabal, containers
, deepseq-generics, directory, distribution-nixpkgs, filepath
, language-nix, lens, monad-par, monad-par-extras, mtl
, optparse-applicative, pretty, SHA, split, stackage-types, stdenv
, text, time, utf8-string, yaml, fetchFromGitHub
}:

mkDerivation rec {
  pname = "hackage2nix";
  version = "20160611";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1zmrqs09zfnwy9cclp78p5nfpg5520p0lnz1myg5q4p6i2251mp3";
  };
  postUnpack = "sourceRoot+=/${pname}";
  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;
  executableHaskellDepends = [
    aeson base bytestring Cabal containers deepseq-generics directory
    distribution-nixpkgs filepath language-nix lens monad-par
    monad-par-extras mtl optparse-applicative pretty SHA split
    stackage-types text time utf8-string yaml
  ];
  postInstall = ''
    exe=$out/bin/${pname}
    mkdir -p $out/share/bash-completion/completions
    $exe --bash-completion-script $exe >$out/share/bash-completion/completions/${pname}
  '';
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ peti ];
}
