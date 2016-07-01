{ mkDerivation, aeson, ansi-wl-pprint, base, bytestring, Cabal
, containers, deepseq, directory, distribution-nixpkgs, fetchFromGitHub
, filepath, hackage-db, language-nix, lens, monad-par
, monad-par-extras, mtl, optparse-applicative, pretty, process, SHA
, split, stackage-types, stdenv, text, time, transformers
, utf8-string, yaml, makeWrapper, nix-prefetch-scripts
}:
mkDerivation rec {
  pname = "cabal2nix";
  version = "20160613-10-g57dddc7";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1nlybd4im80dwq70wqa5k4lji5g353cn6aqiz4v3x4v3fpn2i3qb";
  };
  isExecutable = true;
  enableSharedExecutables = false;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers deepseq
    directory distribution-nixpkgs filepath hackage-db language-nix
    lens optparse-applicative pretty process SHA split text
    transformers yaml
  ];
  executableHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers deepseq
    directory distribution-nixpkgs filepath hackage-db language-nix
    lens monad-par monad-par-extras mtl optparse-applicative pretty
    process SHA split stackage-types text time transformers utf8-string
    yaml
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
  maintainers = [stdenv.lib.maintainers.peti];
}
