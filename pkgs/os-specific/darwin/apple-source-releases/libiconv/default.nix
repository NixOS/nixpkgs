{ stdenv, appleDerivation }:

appleDerivation {
  preConfigure = "cd libiconv";
}
