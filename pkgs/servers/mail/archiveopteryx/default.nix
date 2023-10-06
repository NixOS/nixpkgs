{ lib, stdenv, fetchurl, openssl, perl, zlib, jam }:
stdenv.mkDerivation rec {
  version = "3.2.0";
  pname = "archiveopteryx";

  src = fetchurl {
    url = "http://archiveopteryx.org/download/${pname}-${version}.tar.bz2";
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

  # fix build on gcc7+ and gcc11+
  env.NIX_CFLAGS_COMPILE = toString ([
    "-std=c++11" # c++17+ has errors
    "-Wno-error=builtin-declaration-mismatch"
    "-Wno-error=deprecated-copy"
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=nonnull"
  ] ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
    "-Wno-error=mismatched-new-delete"
  ]);

  buildPhase = ''jam "-j$NIX_BUILD_CORES" '';
  installPhase = ''
    jam install
    mv installroot/$out $out
  '';

  meta = with lib; {
    homepage = "http://archiveopteryx.org/";
    description = "An advanced PostgreSQL-based IMAP/POP server";
    license = licenses.postgresql;
    maintainers = [ maintainers.phunehehe ];
    platforms = platforms.linux;
  };
}
