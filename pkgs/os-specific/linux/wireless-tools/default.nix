{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "wireless-tools-29";

  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz;
    sha256 = "18g5wa3rih89i776nc2n2s50gcds4611gi723h9ki190zqshkf3g";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";
}
