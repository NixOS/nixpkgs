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

  preConfigure = ''export PREFIX="$out" '';
  buildPhase = ''jam "-j$NIX_BUILD_CORES" '';
  installPhase = ''
    jam install
    mkdir -p "$out/share/doc/archiveopteryx"
    mv -t "$out/share/doc/archiveopteryx/" "$out"/{bsd.txt,COPYING,README}
  '';

  meta = with stdenv.lib; {
    homepage = http://archiveopteryx.org/;
    description = "An advanced PostgreSQL-based IMAP/POP server";
    license = licenses.postgresql;
    maintainers = [ maintainers.phunehehe ];
  };
}
