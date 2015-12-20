{ stdenv, fetchurl, openssl, perl, zlib }:
stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "archiveopteryx-${version}";
  src = fetchurl {
    url = "http://archiveopteryx.org/download/${name}.tar.bz2";
    sha256 = "0i0zg8di8nbh96qnyyr156ikwcsq1w9b2291bazm5whb351flmqx";
  };
  buildInputs = [ openssl perl zlib ];
  installPhase = ''
    INSTALLROOT=$out make install
    mkdir $out/bin
    ln --symbolic $out/usr/local/archiveopteryx/sbin/* $out/bin/
    ln --symbolic $out/usr/local/archiveopteryx/bin/* $out/bin/
  '';
  meta = with stdenv.lib; {
    homepage = http://archiveopteryx.org/;
    description = "An advanced PostgreSQL-based IMAP/POP server";
    license = licenses.postgresql;
    maintainers = [ maintainers.phunehehe ];
  };
}
