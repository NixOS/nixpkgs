{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pdfcrack";
  version = "0.18";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    sha256 = "035s3jzrs3ci0i53x04dzpqp9225c4s52cd722d6zqra5b2sw8w2";
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
