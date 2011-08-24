{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libaio-0.3.109";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/aio/${name}.tar.bz2";
    sha256 = "15772ki2wckf2mj4gm1vhrsmpd6rq20983nhlkfghjfblghgrkmm";
  };

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = http://lse.sourceforge.net/io/aio.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
