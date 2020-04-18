{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "csv2latex";
  version = "0.22";

  src = fetchurl {
    url = "http://brouits.free.fr/csv2latex/csv2latex-${version}.tar.gz";
    sha256 = "09qih2zx6cvlii1n5phiinvm9xw1l8f4i60b5hg56pymzjhn97vy";
  };

  installPhase = ''
  mkdir -p $out/bin
  make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "Command-line CSV to LaTeX file converter";
    homepage = "http://brouits.free.fr/csv2latex/";
    license = licenses.gpl2;
    maintainers = [ maintainers.catern ];
  };
}
