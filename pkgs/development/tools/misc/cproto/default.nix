{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "cproto";
  version = "4.7p";

  src = fetchurl {
    urls = [
      "mirror://debian/pool/main/c/cproto/cproto_${version}.orig.tar.gz"
      # No version listings and apparently no versioned tarball over http(s).
      "ftp://ftp.invisible-island.net/cproto/cproto-${version}.tgz"
    ];
    sha256 = "0vm1784yw8gax1r7bzgq0chjgfzwxvmkala2awghmd3zyi7k60nj";
  };

  # patch made by Joe Khoobyar copied from gentoo bugs
  patches = [ ./cproto.patch ];

  nativeBuildInputs = [ flex bison ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    [ "$("$out/bin/cproto" -V 2>&1)" = '${version}' ]
  '';

  meta = with stdenv.lib; {
    description = "Tool to generate C function prototypes from C source code";
    homepage = "https://invisible-island.net/cproto/";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
