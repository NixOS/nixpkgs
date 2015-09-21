{ mkDerivation, base, Cabal, containers, distribution-nixpkgs
, fetchFromGitHub, filepath, language-nix, lens, monad-par
, monad-par-extras, mtl, optparse-applicative, pretty, stdenv
}:

mkDerivation rec {
  pname = "hackage2nix";
  version = "20150903";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1cniaymgwz96bjchan49jv627wjbymc3vs48w1p19qj2k9rly6q7";
  };
  postUnpack = "sourceRoot+=/${pname}";
  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;
  executableHaskellDepends = [
    base Cabal containers distribution-nixpkgs filepath language-nix
    lens monad-par monad-par-extras mtl optparse-applicative pretty
  ];
  postInstall = ''
    exe=$out/bin/${pname}
    mkdir -p $out/share/bash-completion/completions
    $exe --bash-completion-script $exe >$out/share/bash-completion/completions/${pname}
  '';
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
