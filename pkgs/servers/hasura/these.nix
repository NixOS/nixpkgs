{ mkDerivation, aeson, base, base-compat, bifunctors, binary
, containers, data-default-class, deepseq, hashable, keys, lens
, mtl, QuickCheck, quickcheck-instances, semigroupoids, stdenv
, tasty, tasty-quickcheck, transformers, transformers-compat
, unordered-containers, vector, vector-instances
}:
mkDerivation {
  pname = "these";
  version = "0.7.6";
  sha256 = "9464b83d98e626360a8ad9836ba77e5201cd1e9c89b95b1b11a28ef3c23ac746";
  libraryHaskellDepends = [
    aeson base base-compat bifunctors binary containers
    data-default-class deepseq hashable keys lens mtl QuickCheck
    semigroupoids transformers transformers-compat unordered-containers
    vector vector-instances
  ];
  testHaskellDepends = [
    aeson base base-compat bifunctors binary containers hashable lens
    QuickCheck quickcheck-instances tasty tasty-quickcheck transformers
    unordered-containers vector
  ];
  homepage = "https://github.com/isomorphism/these";
  description = "An either-or-both data type & a generalized 'zip with padding' typeclass";
  license = stdenv.lib.licenses.bsd3;
}
