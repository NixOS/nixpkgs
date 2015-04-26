# FIXME: remove gcc49 when the default gcc supports C++1y
{ stdenv, fetchFromGitHub, freetype, gcc49, imlib2, jbig2dec, libjpeg, libX11
, mujs, mupdf, ncurses, openjpeg, openssl }:

let
  version = "0.5.1";
  binaries = [ "jfbpdf" "jfbview" "jpdfcat" "jpdfgrep" ];
in
stdenv.mkDerivation rec {
  name = "jfbview-${version}";

  src = fetchFromGitHub {
    sha256 = "113bkf49q04k9rjps5l28ychmzsfjajp9cjhr433s9ld0972z01m";
    rev = version;
    repo = "JFBView";
    owner = "jichu4n";
  };

  buildInputs = [ freetype gcc49 imlib2 jbig2dec libjpeg libX11 mujs mupdf
    ncurses openjpeg openssl ];

  buildFlags = binaries;
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    install ${toString binaries} $out/bin
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "PDF and image viewer for the Linux framebuffer";
    longDescription = ''
      A very fast PDF and image viewer for the Linux framebuffer with some
      advanced and unique features, including:
      - Reads PDFs (MuPDF) and common image formats (Imlib2)
      - Supports arbitrary zoom (10% - 1000%) and rotation
      - Table of Contents (TOC) viewer for PDF documents
      - Multi-threaded rendering on multi-core machines
      - Asynchronous background rendering of the next page
      - Customizable multi-threaded caching
    '';
    homepage = http://seasonofcode.com/pages/jfbview.html;
    license = with licenses; asl20;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
