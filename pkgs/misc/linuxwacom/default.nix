{stdenv, fetchurl, libX11, libXi}:

stdenv.mkDerivation {
  name = "linuxwacom-0.7.2";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/linuxwacom/linuxwacom-0.7.2.tar.bz2;
    md5 = "3f6290101d5712a24097243ca9f092ed";
  };
  buildInputs = [libX11 libXi];
}
