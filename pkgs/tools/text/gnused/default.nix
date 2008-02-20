{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.1.5";
  
  src = fetchurl {
    url = mirror://gnu/sed/sed-4.1.5.tar.gz;
    md5 = "7a1cbbbb3341287308e140bd4834c3ba";
  };
  
  # !!! hack: this should go away in gnused > 4.1.5
  patches = [./gettext-fix.patch];

  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the Unix sed command";
  };
}
