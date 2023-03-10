{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "pdfcrack";
  version = "0.20";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    hash = "sha256-e4spsY/NXLmErrZA7gbt8J/t5HCbWcMv7k8thoYN5bQ=";
  };

  installPhase = ''
    install -Dt $out/bin pdfcrack
  '';

  meta = with lib; {
    homepage = "https://pdfcrack.sourceforge.net/";
    description = "Small command line driven tool for recovering passwords and content from PDF files";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ qoelet ];
  };
}
