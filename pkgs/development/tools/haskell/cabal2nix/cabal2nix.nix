{ mkDerivation, ansi-wl-pprint, base, Cabal, containers
, distribution-nixpkgs, language-nix, lens, optparse-applicative
, pretty, pretty-show, stdenv, text, yaml
, nix-prefetch-scripts, makeWrapper, fetchFromGitHub
}:

mkDerivation rec {
  pname = "cabal2nix";
  version = "20150922";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "17s800yd8mm48yjjqiayvycaf8z0y1giwp8jp271875wdrx3p75a";
  };
  postUnpack = "sourceRoot+=/${pname}";
  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;
  executableHaskellDepends = [
    ansi-wl-pprint base Cabal containers distribution-nixpkgs
    language-nix lens optparse-applicative pretty pretty-show text yaml
  ];
  executableToolDepends = [ makeWrapper ];
  postInstall = ''
    exe=$out/libexec/${pname}-${version}/${pname}
    install -D $out/bin/${pname} $exe
    rm -rf $out/{bin,lib,share}
    makeWrapper $exe $out/bin/${pname} --prefix PATH ":" "${nix-prefetch-scripts}/bin"
    mkdir -p $out/share/bash-completion/completions
    $exe --bash-completion-script $exe >$out/share/bash-completion/completions/${pname}
  '';
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
