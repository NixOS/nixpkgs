{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "csv2latex";
  version = "0.23.1";

  src = fetchurl {
    url = "http://brouits.free.fr/csv2latex/csv2latex-${version}.tar.gz";
    sha256 = "sha256-k1vQyrVJmfaJ7jVaoW2dkPD7GO8EoDqJY5m8O2U/kYw=";
  };

  installPhase = ''
  mkdir -p $out/bin
  make PREFIX=$out install
  '';

  meta = with lib; {
    description = "Command-line CSV to LaTeX file converter";
    homepage = "http://brouits.free.fr/csv2latex/";
    license = licenses.gpl2;
    maintainers = [ maintainers.catern ];
  };
}
