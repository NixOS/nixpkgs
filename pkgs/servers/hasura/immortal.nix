{ mkDerivation, base, lifted-base, monad-control, stdenv, stm
, tasty, tasty-hunit, transformers, transformers-base
}:
mkDerivation {
  pname = "immortal";
  version = "0.2.2.1";
  sha256 = "ed4aa1a2883a693a73fec47c8c2d5332d61a0626a2013403e1a8fb25cc6c8d8e";
  libraryHaskellDepends = [
    base lifted-base monad-control stm transformers-base
  ];
  testHaskellDepends = [
    base lifted-base stm tasty tasty-hunit transformers
  ];
  homepage = "https://github.com/feuerbach/immortal";
  description = "Spawn threads that never die (unless told to do so)";
  license = stdenv.lib.licenses.mit;
}
