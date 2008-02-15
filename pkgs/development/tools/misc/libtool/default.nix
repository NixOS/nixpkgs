{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation rec {
  name = "libtool-1.5.26";
  src = fetchurl {
    url = "mirror://gnu/libtool/" + name + ".tar.gz";
    sha256 = "029ggq5kri1gjn6nfqmgw4w920gyfzscjjxbsxxidal5zqsawd8w";
  };
  buildInputs = [m4 perl];
}
