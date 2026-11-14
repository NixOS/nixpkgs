{
  mkKdeDerivation,
  perl,
}:
mkKdeDerivation {
  pname = "kdesdk-kio";

  extraNativeBuildInputs = [ perl ];
}
