{ stdenv, fetchurl, pkgconfig, ncurses, confuse, libnl }:

stdenv.mkDerivation {
  name = "bmon-3.1";

  src = fetchurl {
    url = http://www.carisma.slowglass.com/~tgr/bmon/files/bmon-3.1.tar.gz;
    sha256 = "005ib7c3g3cva0rdwsgl6hfakxd5yp88sf4bjxb6iarcm3ax18ky";
  };

  buildInputs = [ pkgconfig ncurses confuse libnl ];

  meta = with stdenv.lib; {
    description = "Network bandwidth monitor";
    homepage = http://www.carisma.slowglass.com/~tgr/bmon/;
    # Neither the homepage nor the source archive has license info, but in the
    # latest git version there is a LICENSE file that is the 2-clause BSD
    # license.
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE
    #  - http://opensource.org/licenses/BSD-2-Clause
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
