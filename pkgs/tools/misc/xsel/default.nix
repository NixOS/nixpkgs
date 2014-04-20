{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "xsel-1.2.0";
  src = fetchurl {
    url = http://www.vergenet.net/~conrad/software/xsel/download/xsel-1.2.0.tar.gz;
    sha256 = "070lbcpw77j143jrbkh0y1v10ppn1jwmjf92800w7x42vh4cw9xr";
  };

  buildInputs = [x11];
}
