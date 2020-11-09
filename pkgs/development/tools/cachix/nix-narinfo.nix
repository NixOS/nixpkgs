{ mkDerivation, attoparsec, base, containers, filepath, hspec
 , QuickCheck, text, stdenv
 }:
 mkDerivation {
   pname = "nix-narinfo";
   version = "0.1.0.1";
   sha256 = "0bw5whywbhcj18y733wqq5cgci4yijrz648sby8r3qihn8man3ch";
   isLibrary = true;
   isExecutable = true;
   libraryHaskellDepends = [ attoparsec base containers text ];
   executableHaskellDepends = [ attoparsec base text ];
   testHaskellDepends = [
     attoparsec base filepath hspec QuickCheck text
   ];
   description = "Parse and render .narinfo files";
   license = stdenv.lib.licenses.bsd3;
   maintainers = with stdenv.lib.maintainers; [ sorki ];
 }

