{ stdenv, lib, fetchurl, wkhtmltopdf, xar, cpio }:

stdenv.mkDerivation rec {

  pname = "wkhtmltopdf-bin";
  version = "0.12.6-1";
  sha256 = "1db59kdprzpmvdj1bg47lmfgi3zlvzvqif11sbym9hw61xy6gp3d";
  src = fetchurl {
    url =
      "https://github.com/wkhtmltopdf/packaging/releases/download/${version}/wkhtmltox-${version}.macos-cocoa.pkg";
    inherit sha256;
  };

  buildInputs = [ xar cpio ];

  unpackPhase = ''
    xar -xf $src
    zcat Payload | cpio -i
    tar -xf usr/local/share/wkhtmltox-installer/wkhtmltox.tar.gz
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin include lib share $out/
  '';

  dontStrip = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/wkhtmltopdf --version
  '';

  meta = with lib; {
    homepage = "https://wkhtmltopdf.org/";
    description =
      "Tools for rendering web pages to PDF or images (binary package)";
    longDescription = ''
      wkhtmltopdf and wkhtmltoimage are open source (LGPL) command line tools
      to render HTML into PDF and various image formats using the QT Webkit
      rendering engine. These run entirely "headless" and do not require a
      display or display service.

      There is also a C library, if you're into that kind of thing.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nbr ];
    platforms = [ "x86_64-darwin" ];
  };
}
