{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.5";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ed/ed-0.5.tar.bz2;
    sha256 = "0gjzsdpha28q7fddwvwxa6h87x13sgg0wakq6a1diw7vw2yjpvzd";
  };
}
