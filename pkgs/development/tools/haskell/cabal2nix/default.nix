{ mkDerivation, fetchgit, aeson, base, bytestring, Cabal, containers
, deepseq, deepseq-generics, directory, doctest, filepath, gitMinimal
, hackage-db, hspec, lens, monad-par, monad-par-extras, mtl, pretty
, process, QuickCheck, regex-posix, SHA, split, stdenv, transformers
, utf8-string, cartel, nix-prefetch-scripts, optparse-applicative
, makeWrapper
}:

mkDerivation rec {
  pname = "cabal2nix";
  version = "20150531";
  src = fetchgit {
    url = "http://github.com/NixOS/cabal2nix.git";
    rev = "513a5fce6cfabe0b062424f6deb191a12f7e2187";
    sha256 = "1rsnzgfzw6zrjwwr3a4qbhw4l07pqi9ddm2p9l3sw3agzwmc7z49";
    deepClone = true;
  };
  isExecutable = true;
  enableSharedLibraries = false;
  enableSharedExecutables = false;
  buildDepends = [
    aeson base bytestring Cabal containers deepseq-generics directory
    filepath hackage-db lens monad-par monad-par-extras mtl pretty
    process regex-posix SHA split transformers utf8-string cartel
    optparse-applicative
  ];
  testDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec lens monad-par
    monad-par-extras mtl pretty process QuickCheck regex-posix SHA
    split transformers utf8-string
  ];
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
}
