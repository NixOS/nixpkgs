{ stdenv, lib, fetchurl, fetchpatch, ncurses }:

stdenv.mkDerivation rec {
  pname = "smemstat";
  version = "0.02.10";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.xz";
    sha256 = "sha256-Vrs1jOg5yHdEffVo769aaxSawo4iZtGrFJ65Nu+RhcU=";
  };
  patches = [
    # Pull patch pending upstream inclusion to support ncurses-6.3:
    #  https://github.com/ColinIanKing/smemstat/pull/1
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/ColinIanKing/smemstat/commit/95119558d1679295c9f9f7f618ddbe212674a4bf.patch";
      sha256 = "sha256-Cl3Y0HIy1nXqBux6+AXoPuKJatSv3Z0X/4bD+MNjkAQ=";
    })
  ];
  buildInputs = [ ncurses ];
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
