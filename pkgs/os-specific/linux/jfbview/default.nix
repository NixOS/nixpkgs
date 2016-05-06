{ stdenv, fetchFromGitHub
, freetype, harfbuzz, imlib2, jbig2dec, libjpeg, libX11, mujs, mupdf
, ncurses, openjpeg, openssl }:

let
  binaries = [ "jfbpdf" "jfbview" "jpdfcat" "jpdfgrep" ];
in
stdenv.mkDerivation rec {
  name = "jfbview-${version}";
  version = "0.5.2";

  src = fetchFromGitHub {
    sha256 = "1vd2ndl4ar2bzqf0k11qid6gvma59qg62imsa81mgczsqw7kvbx6";
    rev = version;
    repo = "JFBView";
    owner = "jichu4n";
  };

  buildInputs = [ freetype harfbuzz imlib2 jbig2dec libjpeg libX11 mujs mupdf
    ncurses openjpeg openssl ];

  configurePhase = ''
    # Hack. Probing (with `ldconfig -p`) fails with ‘cannot execute binary file’.
    # Overriding `OPENJP2 = ...` later works, but makes build output misleading:
    substituteInPlace Makefile --replace "ldconfig -p" "echo libopenjp2"

    make config.mk
  '';

  buildFlags = binaries;
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    install ${toString binaries} $out/bin
  '';

  meta = with stdenv.lib; {
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
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
