{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kitemviews";

  extraNativeBuildInputs = [ qttools ];
}
