{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "eject-2.1.5";
  #builder = ./builder.sh;
  src = fetchurl {
    url = http://ca.geocities.com/jefftranter@rogers.com/eject-2.1.5.tar.gz;
    sha256 = "0mgy5wp40rsalfkxs6mvsg3s7yaqf2iq49iv4axf9zac9037k7zg";
  };
  buildInputs = [gettext];
  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";
}
