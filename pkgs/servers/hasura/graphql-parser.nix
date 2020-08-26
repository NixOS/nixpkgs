{ mkDerivation, aeson, attoparsec, base, bytestring, containers
, criterion, fetchgit, filepath, hedgehog, hpack, prettyprinter
, protolude, regex-tdfa, scientific, stdenv, template-haskell, text
, text-builder, th-lift-instances, unordered-containers, vector
}:
mkDerivation {
  pname = "graphql-parser";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/hasura/graphql-parser-hs.git";
    sha256 = "0vz0sqqmr1l02d3f1pc5k7rm7vpxmg5d5ijvdcwdm34yw6x5lz1v";
    rev = "623ad78aa46e7ba2ef1aa58134ad6136b0a85071";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson attoparsec base bytestring containers filepath hedgehog
    prettyprinter protolude regex-tdfa scientific template-haskell text
    text-builder th-lift-instances unordered-containers vector
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    aeson attoparsec base bytestring containers filepath hedgehog
    prettyprinter protolude regex-tdfa scientific template-haskell text
    text-builder th-lift-instances unordered-containers vector
  ];
  benchmarkHaskellDepends = [
    aeson attoparsec base bytestring containers criterion filepath
    hedgehog prettyprinter protolude regex-tdfa scientific
    template-haskell text text-builder th-lift-instances
    unordered-containers vector
  ];
  prePatch = "hpack";
  homepage = "https://github.com/hasura/graphql-parser-hs#readme";
  license = stdenv.lib.licenses.bsd3;
}
