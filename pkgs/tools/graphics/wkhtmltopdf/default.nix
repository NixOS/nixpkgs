{ stdenv, fetchFromGitHub, qt5, fontconfig, freetype, libpng, zlib, libjpeg
, openssl, libX11, libXext, libXrender }:

stdenv.mkDerivation rec {
  version = "0.12.5";
  name = "wkhtmltopdf-${version}";

  src = fetchFromGitHub {
    owner  = "wkhtmltopdf";
    repo   = "wkhtmltopdf";
    rev    = version;
    sha256 = "0i6b6z3f4szspbbi23qr3hv22j9bhmcj7c1jizr7y0ra43mrgws1";
  };

  buildInputs = [
    fontconfig freetype libpng zlib libjpeg openssl
    libX11 libXext libXrender
    qt5.qtwebkit qt5.qtsvg
  ];

  prePatch = ''
    for f in src/image/image.pro src/pdf/pdf.pro ; do
      substituteInPlace $f --replace '$(INSTALL_ROOT)' ""
    done
  '';

  configurePhase = "qmake wkhtmltopdf.pro INSTALLBASE=$out";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wkhtmltopdf.org/;
    description = "Tools for rendering web pages to PDF or images";
    longDescription = ''
      wkhtmltopdf and wkhtmltoimage are open source (LGPL) command line tools
      to render HTML into PDF and various image formats using the QT Webkit
      rendering engine. These run entirely "headless" and do not require a
      display or display service.

      There is also a C library, if you're into that kind of thing.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jb55 ];
    platforms = with platforms; linux;
  };
}
