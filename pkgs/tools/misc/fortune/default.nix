{ stdenv, fetchurl, recode }:

stdenv.mkDerivation {
  name = "fortune-mod_1.99.1";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/f/fortune-mod/fortune-mod_1.99.1.orig.tar.gz;
    sha256 = "1kpa2hgbglj5dbfasvl9wc1q3xpl91mqn3sfby46r4rwyzhswlgw";
  };
  buildInputs = [recode];
  preConfigure = ''
    sed -i "s|/usr/|$out/|" Makefile 
  '';
  postInstall = ''
    ln -s $out/games/fortune $out/bin/fortune
  '';

  meta = {
    description = "fortune is a simple program that displays a pseudorandom message from a database of quotations that first appeared in Version 7 Unix.";
  };
}
