{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "cproto-${version}";
  version = "4.7o";

  src = fetchurl {
    urls = [
      "mirror://debian/pool/main/c/cproto/cproto_${version}.orig.tar.gz"
      # No version listings and apparently no versioned tarball over http(s).
      "ftp://ftp.invisible-island.net/cproto/cproto-${version}.tgz"
    ];
    sha256 = "0kxlrhhgm84v2q6n3wp7bb77g7wjxkb7azdvb6a70naf0rr0nsy7";
  };

  # patch made by Joe Khoobyar copied from gentoo bugs
  patches = ./cproto_patch;

  nativeBuildInputs = [ flex bison ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    [ "$("$out/bin/cproto" -V 2>&1)" = '${version}' ]
  '';

  meta = with stdenv.lib; {
    description = "Tool to generate C function prototypes from C source code";
    homepage = https://invisible-island.net/cproto/;
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}
