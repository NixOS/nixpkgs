{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "agrep-${version}";
  version = "3.41.5";

  src = fetchFromGitHub {
    owner = "Wikinaut";
    repo = "agrep";
    # This repository has numbered versions, but not Git tags.
    rev = "eef20411d605d9d17ead07a0ade75046f2728e21";
    sha256 = "14addnwspdf2mxpqyrw8b84bb2257y43g5ccy4ipgrr91fmxq2sk";
  };

  installPhase = ''
    install -Dm 555 agrep -t "$out/bin"
    install -Dm 444 docs/* -t "$out/doc"
  '';

  meta = {
    description = "Approximate grep for fast fuzzy string searching";
    homepage = https://www.tgries.de/agrep/;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
  };
}
