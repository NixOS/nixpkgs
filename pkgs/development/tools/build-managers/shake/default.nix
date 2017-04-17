{ mkDerivation, base, binary, bytestring, deepseq, directory, extra
, filepath, hashable, js-flot, js-jquery, old-time, process
, QuickCheck, random, stdenv, time, transformers, unix
, unordered-containers, utf8-string
, gcc
}:
mkDerivation {
  pname = "shake";
  version = "0.15.4";
  sha256 = "189qyxvy6rxlkgmssy2v66f7anp4q9xjmwqcpwxq86h0pj7vr3i9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base binary bytestring deepseq directory extra filepath hashable
    js-flot js-jquery old-time process random time transformers unix
    unordered-containers utf8-string
  ];
  testDepends = [
    base binary bytestring deepseq directory extra filepath hashable
    js-flot js-jquery old-time process QuickCheck random time
    transformers unix unordered-containers utf8-string
    gcc
  ];
  homepage = http://shakebuild.com;
  description = "Build system library, like Make, but more accurate dependencies";
  license = stdenv.lib.licenses.bsd3;
}
