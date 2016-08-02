{ stdenv, fetchurl, openssl, perl, zlib, jam }:
stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "archiveopteryx-${version}";

  src = fetchurl {
    url = "http://archiveopteryx.org/download/${name}.tar.bz2";
    sha256 = "0i0zg8di8nbh96qnyyr156ikwcsq1w9b2291bazm5whb351flmqx";
  };

  nativeBuildInputs = [ jam ];
  buildInputs = [ openssl perl zlib ];

  preConfigure = ''
    export INSTALLROOT=installroot
    sed -i 's:BINDIR = $(PREFIX)/bin:BINDIR = '$out'/bin:' ./Jamsettings
    sed -i 's:SBINDIR = $(PREFIX)/sbin:SBINDIR = '$out'/bin:' ./Jamsettings
    sed -i 's:LIBDIR = $(PREFIX)/lib:LIBDIR = '$out'/lib:' ./Jamsettings
    sed -i 's:MANDIR = $(PREFIX)/man:MANDIR = '$out'/share/man:' ./Jamsettings
    sed -i 's:READMEDIR = $(PREFIX):READMEDIR = '$out'/share/doc/archiveopteryx:' ./Jamsettings
  '';
  buildPhase = ''jam "-j$NIX_BUILD_CORES" '';
  installPhase = ''
    jam install
    mv installroot/$out $out
  '';

  meta = with stdenv.lib; {
    homepage = http://archiveopteryx.org/;
    description = "An advanced PostgreSQL-based IMAP/POP server";
    license = licenses.postgresql;
    maintainers = [ maintainers.phunehehe ];
    platforms = platforms.linux;
  };
}
