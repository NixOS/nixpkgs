{ mkDerivation, aeson, base, jose, lens, servant, stdenv, text
, unordered-containers
}:
mkDerivation {
  pname = "servant-auth";
  version = "0.4.0.0";
  sha256 = "01cacafa34bdb0aac88ae31d9f12ee6fa349fcb76acc2592e697cba926404f6c";
  libraryHaskellDepends = [
    aeson base jose lens servant text unordered-containers
  ];
  homepage = "http://github.com/haskell-servant/servant-auth#readme";
  description = "Authentication combinators for servant";
  license = stdenv.lib.licenses.bsd3;
}
