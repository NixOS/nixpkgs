{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-475";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "16703m6g5l97af3jwpypgac7gpmh3yjkdpqygf5a2scfip0hxm2g";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  preConfigure = "chmod +x ./configure";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
