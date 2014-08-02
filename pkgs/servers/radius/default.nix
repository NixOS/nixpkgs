{ fetchurl, stdenv, m4, groff, readline }:

stdenv.mkDerivation rec {
  name = "radius-1.6.1";

  src = fetchurl {
    url = "mirror://gnu/radius/${name}.tar.gz";
    sha256 = "1l4k17zkbjsmk8mqrjjymagq8a8kwgrain9mcb5zp8jaf1qbclrh";
  };

  buildInputs = [ m4 groff readline ] ;

  doCheck = true;

  meta = {
    description = "GNU Radius remote authentication and accounting system";

    longDescription =
      '' Radius is a server for remote user authentication and
         accounting.  Its primary use is for Internet Service
         Providers, though it may as well be used on any network that
         needs a centralized authentication and/or accounting service
         for its workstations.  The package includes an authentication
         and accounting server and administrator tools.
      '';

    homepage = http://www.gnu.org/software/radius/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;

    broken = true;
  };
}
