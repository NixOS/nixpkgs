{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "pdfcrack-${version}";
  version = "0.16";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    sha256 = "1vvkrg3niinz0j9wwm31laxgmd7wdz201kn82b3dbksc0w1v4rbq";
  };

  installPhase = ''
    install -Dt $out/bin pdfcrack
  '';

  meta = with lib; {
    homepage = http://pdfcrack.sourceforge.net/;
    description = "Small command line driven tool for recovering passwords and content from PDF files";
    license = with licenses; [ gpl2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ qoelet ];
  };
}
