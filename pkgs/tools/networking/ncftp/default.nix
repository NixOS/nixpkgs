{ lib, stdenv, fetchurl, ncurses, coreutils }:

stdenv.mkDerivation rec {
  pname = "ncftp";
  version = "3.2.6";

  src = fetchurl {
    url = "ftp://ftp.ncftp.com/ncftp/ncftp-${version}-src.tar.xz";
    sha256 = "1389657cwgw5a3kljnqmhvfh4vr2gcr71dwz1mlhf22xq23hc82z";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: bookmark.o: (.bss+0x20): multiple definition of `gBm';
  #     gpshare.o:(.bss+0x0): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    find -name Makefile.in | xargs sed -i '/^TMPDIR=/d'

    find . -name '*.sh' -or -name '*.in' -or -name '*.c' -or -name configure | xargs sed -i \
      -e 's@/bin/ls@${coreutils}/bin/ls@g' \
      -e 's@/bin/rm@${coreutils}/bin/rm@g'
  '';

  postInstall = ''
    rmdir $out/etc
    mkdir -p $out/share/doc
    cp -r doc $out/share/doc/ncftp
  '';

  configureFlags = [
    "--enable-ssp"
    "--mandir=$(out)/share/man/"
  ];

  meta = with lib; {
    description = "Command line FTP (File Transfer Protocol) client";
    homepage = "https://www.ncftp.com/ncftp/";
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
    license = licenses.clArtistic;
  };
}
