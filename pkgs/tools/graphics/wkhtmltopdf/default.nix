{ stdenv, fetchgit, qt4, fontconfig, freetype, libpng, zlib, libjpeg
, openssl, libX11, libXext, libXrender, overrideDerivation }:

stdenv.mkDerivation rec {
  version = "0.12.1";
  name = "wkhtmltopdf-${version}";

  src = fetchgit {
    url = "https://github.com/wkhtmltopdf/wkhtmltopdf.git";
    rev = "refs/tags/${version}";
    sha256 = "0wjzaaviy1k3z8r2kzb2rmyx6xdj23a338b86sxcb15ws3kzwgwh";
  };

  wkQt = overrideDerivation qt4 (deriv: {
    name = "qt-mod-4.8.6";
    src = fetchgit {
      url = "https://github.com/wkhtmltopdf/qt.git";
      rev = "82b568b"; # From git submodule spec in wkhtml repo.
      sha256 = "0whppwxnymh5bdayqsqx54n074m99yk6v78z7f0k5prja55yvwyx";
    };
    configureFlags =
      ''
        -v -no-separate-debug-info -release -confirm-license -opensource
        -qdbus -glib -dbus-linked -openssl-linked
      ''
      + # This is taken from the wkhtml build script that we don't run
      ''
        -fast
        -static
        -exceptions
        -xmlpatterns
        -webkit
        -system-zlib
        -system-libpng
        -system-libjpeg
        -no-libmng
        -no-libtiff
        -no-accessibility
        -no-stl
        -no-qt3support
        -no-phonon
        -no-phonon-backend
        -no-opengl
        -no-declarative
        -no-sql-ibase
        -no-sql-mysql
        -no-sql-odbc
        -no-sql-psql
        -no-sql-sqlite
        -no-sql-sqlite2
        -no-mmx
        -no-3dnow
        -no-sse
        -no-sse2
        -no-multimedia
        -nomake demos
        -nomake docs
        -nomake examples
        -nomake tools
        -nomake tests
        -nomake translations
      '';
  });

  buildInputs = [ wkQt fontconfig freetype libpng zlib libjpeg openssl
    libX11 libXext libXrender
    ];

  configurePhase = "qmake wkhtmltopdf.pro INSTALLBASE=$out";
  
  patches = [ ./makefix.patch ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://wkhtmltopdf.org/;
    description = "Tools for rendering web pages to PDF or images";
    longDescription = ''
      wkhtmltopdf and wkhtmltoimage are open source (LGPL) command line tools
      to render HTML into PDF and various image formats using the QT Webkit
      rendering engine. These run entirely "headless" and do not require a
      display or display service.

      There is also a C library, if you're into that kind of thing.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
