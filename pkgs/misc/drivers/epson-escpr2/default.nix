{ stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  name = "epson-inkjet-printer-escpr2-${version}";
  version = "1.0.29";

  src = fetchurl {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/09/02/31/a332507b6398c6e2e007c05477dd6c3d5a8e50eb/${name}-1lsb3.2.src.rpm";
    sha256 = "064br52akpw5yrxb2wqw2klv4jrvyipa7w0rjj974xgyi781lqs5";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups busybox ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv

    tar xvf ${name}-1lsb3.2.tar.gz
    cd ${name}
  '';

  meta = with stdenv.lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma9e ];
    platforms = platforms.linux;
  };
}
