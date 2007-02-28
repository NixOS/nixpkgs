{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "wireless-tools-29-pre12";

  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.pre12.tar.gz;
    sha256 = "12al9910k2d9a0464j1r1x3lcsyw36zd2hzbyqy357iplplkxnws";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";

  #buildInputs = [bison flex openssl];
}
