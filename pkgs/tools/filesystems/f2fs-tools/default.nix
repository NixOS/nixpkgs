{ stdenv, fetchurl, autoreconfHook, libuuid, pkgconfig }:

stdenv.mkDerivation rec {
  name = "f2fs-tools-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot/${name}.tar.gz";
    sha256 = "1pdgl78xkagxlmavy6x118wjzz8yvl8n08fc1m6wah9bf93qlhdf";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ehmry jagajaga ];
  };
}
