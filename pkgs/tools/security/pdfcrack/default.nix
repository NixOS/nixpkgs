{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "pdfcrack-${version}";
  version = "0.17";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    sha256 = "15hfxwr9yfzkx842p0jjdjnjarny6qc5fwcpy2f6lnq047pb26sn";
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
