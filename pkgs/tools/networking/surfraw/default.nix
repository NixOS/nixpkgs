{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "surfraw-2.2.8";

  src = fetchurl {
    url = "http://surfraw.alioth.debian.org/dist/surfraw-2.2.8.tar.gz";
    sha256 = "925075e05637e39458b00e859193aacde306aafd9a962f44f5114f81713539ec";
  };

  configureFlags = [
    "--disable-opensearch"
  ];

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Provides a fast unix command line interface to a variety of popular WWW search engines and other artifacts of power";
    homepage = "http://surfraw.alioth.debian.org";
    maintainers = [];
  };
}
