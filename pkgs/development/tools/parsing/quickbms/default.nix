{ stdenv, fetchurl, pkgconfig, unzip, lzo, bzip2, zlib, openssl }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "0.10.1";
  pname = "quickbms";

  src = fetchurl {
    url = "http://aluigi.zenhax.com/papers/quickbms-src-${version}.zip";
    sha256 = "172588jc60irrafjwz4dhy0h08hc7s5c68mmq5v6140yv3f9ixc0";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ lzo bzip2 zlib openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Files extractor and reimporter, archives and file formats parser";
    homepage = "http://quickbms.com";
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
