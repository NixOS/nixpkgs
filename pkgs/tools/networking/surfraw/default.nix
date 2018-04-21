{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "surfraw-2.3.0";

  src = fetchurl {
    url = "http://surfraw.alioth.debian.org/dist/surfraw-2.3.0.tar.gz";
    sha256 = "099nbif0x5cbcf18snc58nx1a3q7z0v9br9p2jiq9pcc7ic2015d";
  };

  configureFlags = [
    "--disable-opensearch"
  ];

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Provides a fast unix command line interface to a variety of popular WWW search engines and other artifacts of power";
    homepage = http://surfraw.alioth.debian.org;
    maintainers = [];
    platforms = stdenv.lib.platforms.linux;
  };
}
