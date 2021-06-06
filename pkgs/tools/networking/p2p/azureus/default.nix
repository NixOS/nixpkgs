{lib, stdenv, fetchurl, jdk, swt}:

stdenv.mkDerivation {
  name = "azureus-2.3.0.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = "http://tarballs.nixos.org/Azureus2.3.0.6.jar";
    sha256 = "1hwrh3n0b0jbpsdk15zrs7pw175418phhmg6pn4xi1bvilxq1wrd";
  };

  inherit jdk swt;

  meta = {
    platforms = lib.platforms.linux;
  };
}
