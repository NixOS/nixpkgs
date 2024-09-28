{ lib, stdenv, fetchurl, cups, cmake }:

stdenv.mkDerivation {
  pname = "epson-tm-m30ii";
  version = "3.0.0.0";

  src = fetchurl {
    url = "https://www.epson-biz.com/modules/pos/download.php?fid=9468";
    curlOptsList = ["-X" "POST" "-H" "Cookie: service=pos" "--data-raw" "DownloadSubmit=Download..."];
    hash = "sha256-gQU0DyKw/wwwjK1cyF4Nnh6F1k6lCgIPq6ctmCfUjB0=";
    name = "epson-tm-m30ii.tar.gz";
  };

  buildInputs = [ cups cmake ];

  installPhase = ''
    mkdir -p $out/lib/cups/filter
    install -s rastertotmtr $out/lib/cups/filter

    install -m 755 -d $out/share/cups/model/EPSON
    install -m 755 ../ppd/*.ppd $out/share/cups/model/EPSON
  '';

  meta = with lib; {
    homepage = "https://www.epson-biz.com/modules/pos/index.php?page=prod&pcat=3&pid=6370";
    description = "Driver for the EPSON TM-m30II thermal printer";
    longDescription = ''
      Epson thermal printer driver for the TM-m30ii printer for Linux
      and the corresponding PPD files.

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.${pname} ];
        };'';
    license = licenses.gpl2;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
  };
}
