{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "wireless-tools-29-pre17";

  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.pre17.tar.gz;
    sha256 = "13488mk5q8zdb6z933287kf2sf2narkn4khni5z3x7y87jvrs127";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";
}
