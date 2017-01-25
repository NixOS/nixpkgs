{ stdenv, fetchurl, autoreconfHook, libselinux, libuuid, pkgconfig }:

stdenv.mkDerivation rec {
  name = "f2fs-tools-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot/${name}.tar.gz";
    sha256 = "1m6bn1ibq0p53m0n97il91xqgjgn2pzlz74lb5bfzassx7159m1k";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libselinux libuuid pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ehmry jagajaga ];
  };
}
