{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pdfcrack";
  version = "0.19";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    sha256 = "1vf0l83xk627fg0a3b10wabgqxy08q4vbm0xjw9xzkdpk1lj059i";
  };

  installPhase = ''
    install -Dt $out/bin pdfcrack
  '';

  meta = with lib; {
    homepage = "http://pdfcrack.sourceforge.net/";
    description = "Small command line driven tool for recovering passwords and content from PDF files";
    license = with licenses; [ gpl2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ qoelet ];
  };
}
