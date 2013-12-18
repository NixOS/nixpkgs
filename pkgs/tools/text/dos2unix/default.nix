{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation {
  name = "dos2unix-6.0.3";
  
  src = fetchurl {
    url = http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.3.tar.gz;
    sha256 = "014sxyidqmjvc5xp5dmcimxd3apl8gyv6whc44vkb65151dqq9pm";
  };

  configurePhase = ''
    sed -i -e s,/usr,$out, Makefile
  '';

  buildInputs = [ perl gettext ];

  meta = {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
