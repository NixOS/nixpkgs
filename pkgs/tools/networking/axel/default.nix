{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "axel-2.4";
  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3016/axel-2.4.tar.bz2;
    sha256 = "ebc7d40e989c680d2afa632a17e5208101608924cf446da20814a6f3c3338612";
  };

  meta = {
    description = "A console downloading program. Has some features for parallel connections for faster downloading.";
  };
}
