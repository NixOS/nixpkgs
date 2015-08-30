{ mkDerivation, fetchgit, aeson, ansi-wl-pprint, base, bytestring, Cabal
, containers, deepseq, deepseq-generics, directory, doctest, filepath
, hackage-db, hspec, lens, monad-par, monad-par-extras, mtl
, optparse-applicative, pretty, process, QuickCheck, regex-posix, SHA, split
, stdenv, transformers, utf8-string, makeWrapper, gitMinimal, cartel, data-default
, nix-prefetch-scripts
}:

mkDerivation rec {
  pname = "cabal2nix";
  version = "20150824";
  src = fetchgit {
    url = "http://github.com/NixOS/cabal2nix.git";
    rev = "560fb2b1d22f4c995a526529bb034bd183e85a31";
    sha256 = "1pyjy9kb8g18g6shlg7vnyaspa892zaq4hqvmqvdbxrlf24vg0wp";
    deepClone = true;
  };
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers
    deepseq-generics directory filepath hackage-db lens monad-par
    monad-par-extras mtl optparse-applicative pretty process
    regex-posix SHA split transformers utf8-string data-default
  ];
  executableHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers
    deepseq-generics directory filepath hackage-db lens monad-par
    monad-par-extras mtl optparse-applicative pretty process
    regex-posix SHA split transformers utf8-string data-default
  ];
  testHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers deepseq
    deepseq-generics directory doctest filepath hackage-db hspec lens
    monad-par monad-par-extras mtl optparse-applicative pretty process
    QuickCheck regex-posix SHA split transformers utf8-string data-default
  ];
  buildDepends = [ cartel ];
  buildTools = [ gitMinimal makeWrapper ];
  preConfigure = ''
    git reset --hard # Re-create the index that fetchgit destroyed in the name of predictable hashes.
    runhaskell $setupCompileFlags generate-cabal-file --release >cabal2nix.cabal
  '';
  postInstall = ''
    exe=$out/libexec/${pname}-${version}/cabal2nix
    install -D $out/bin/cabal2nix $exe
    rm -rf $out/{bin,lib,share}
    makeWrapper $exe $out/bin/cabal2nix --prefix PATH ":" "${nix-prefetch-scripts}/bin"
    mkdir -p $out/share/bash-completion/completions
    $exe --bash-completion-script $exe >$out/share/bash-completion/completions/cabal2nix
  '';
  homepage = "http://github.com/NixOS/cabal2nix/";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
