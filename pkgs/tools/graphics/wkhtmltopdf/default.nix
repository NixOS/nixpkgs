{ mkDerivation, lib, fetchFromGitHub, qtwebkit, qtsvg, qtxmlpatterns
, fontconfig, freetype, libpng, zlib, libjpeg
, openssl, libX11, libXext, libXrender }:

mkDerivation rec {
  version = "0.12.6";
  pname = "wkhtmltopdf";

  src = fetchFromGitHub {
    owner  = "wkhtmltopdf";
    repo   = "wkhtmltopdf";
    rev    = version;
    sha256 = "0m2zy986kzcpg0g3bvvm815ap9n5ann5f6bdy7pfj6jv482bm5mg";
  };

  buildInputs = [
    fontconfig freetype libpng zlib libjpeg openssl
    libX11 libXext libXrender
    qtwebkit qtsvg qtxmlpatterns
  ];

  prePatch = ''
    for f in src/image/image.pro src/pdf/pdf.pro ; do
      substituteInPlace $f --replace '$(INSTALL_ROOT)' ""
    done
  '';

  configurePhase = "qmake wkhtmltopdf.pro INSTALLBASE=$out";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://wkhtmltopdf.org/";
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
