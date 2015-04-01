{ stdenv, fetchFromGitHub, freetype, imlib2, jbig2dec, libjpeg, libX11, mujs
, mupdf, ncurses, openjpeg, openssl }:

stdenv.mkDerivation rec {
  version = "0.4.2"; # TODO: update to 0.5 or later when nixpkgs has caught up
  name = "jfbview-${version}";

  src = fetchFromGitHub {
    repo = "JFBView";
    owner = "jichu4n";
    rev = version;
    sha256 = "1hhlzvs0jhygd3mqpzg5zymrbay9c8ilc4wjnwg00lvxhv3rwswr";
  };

  buildInputs = [ freetype imlib2 jbig2dec libjpeg libX11 mujs mupdf ncurses
    openjpeg openssl ];

  enableParallelBuilding = true;

  makeFlags = "jfbpdf jfbview";

  installPhase = ''
    mkdir -p $out/bin
    install jfbpdf jfbview $out/bin
  '';

  meta = with stdenv.lib; {
    description = "PDF and image viewer for the Linux framebuffer";
    longDescription = ''
      PDF and image viewer for the Linux framebuffer. Very fast with a number
      of advanced and unique features including:
      - Reads PDFs (MuPDF) and common image formats (Imlib2).
      - Supports arbitrary zoom (10% - 1000%) and rotation.
      - Table of Contents (TOC) viewer for PDF documents.
      - Multi-threaded rendering on multi-core machines.
      - Asynchronous background rendering of the next page.
      - Customizable multi-threaded caching.
    '';
    homepage = http://seasonofcode.com/pages/jfbview.html;
    license = with licenses; asl20;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
