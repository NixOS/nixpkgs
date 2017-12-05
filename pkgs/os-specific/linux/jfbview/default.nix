{ stdenv, fetchFromGitHub
, freetype, harfbuzz, jbig2dec, libjpeg, libX11, mujs, mupdf, ncurses, openjpeg
, openssl

, imageSupport ? true, imlib2 ? null }:

let
  package = if imageSupport
    then "jfbview"
    else "jfbpdf";
  binaries = if imageSupport
    then [ "jfbview" "jpdfcat" "jpdfgrep" ] # all require imlib2
    else [ "jfbpdf" ]; # does not
in

stdenv.mkDerivation rec {
  name = "${package}-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    sha256 = "18iyvisslqp5ibhix00j4y7q8fmf2a79chflimc78xf52x4m2p5q";
    rev = version;
    repo = "JFBView";
    owner = "jichu4n";
  };

  buildInputs = [
    freetype harfbuzz jbig2dec libjpeg libX11 mujs mupdf ncurses openjpeg
    openssl
  ] ++ stdenv.lib.optionals imageSupport [
    imlib2
  ];

  patches = [
    ./mupdf-1.9.patch
  ];

  configurePhase = ''
    # Hack. Probing (`ldconfig -p`) fails with ‘cannot execute binary file’.
    # Overriding `OPENJP2 =` later works, but makes build output misleading:
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
    homepage = https://seasonofcode.com/pages/jfbview.html;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
