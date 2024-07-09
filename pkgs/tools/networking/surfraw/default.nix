{lib, stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  pname = "surfraw";
  version = "2.3.0";

  src = fetchurl {
    url = "https://gitlab.com/surfraw/Surfraw/uploads/2de827b2786ef2fe43b6f07913ca7b7f/surfraw-${version}.tar.gz";
    sha256 = "099nbif0x5cbcf18snc58nx1a3q7z0v9br9p2jiq9pcc7ic2015d";
  };

  configureFlags = [
    "--disable-opensearch"
  ];

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Provides a fast unix command line interface to a variety of popular WWW search engines and other artifacts of power";
    homepage = "https://gitlab.com/surfraw/Surfraw";
    maintainers = [];
    platforms = lib.platforms.all;
    license = lib.licenses.publicDomain;
  };
}
