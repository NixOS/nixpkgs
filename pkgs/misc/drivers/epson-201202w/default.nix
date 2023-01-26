{ lib, stdenv, fetchurl, rpmextract, autoreconfHook, file, libjpeg, cups }:

  stdenv.mkDerivation rec {
  
    version = "1.0.0";
  
    filterVersion = "1.0.0";

    pname = "epson-201202w";
    inherit version;

    src = fetchurl {
      # NOTE: Don't forget to update the webarchive link too!
      urls = [
        "http://download.ebz.epson.net/dsc/f/01/00/01/77/09/d9c270238d35e885c89b4686665b383be8308fb8/epson-inkjet-printer-201202w-${version}-1lsb3.2.src.rpm"
        "http://web.archive.org/web/20220212002603/http://download.ebz.epson.net/dsc/f/01/00/01/77/09/d9c270238d35e885c89b4686665b383be8308fb8/epson-inkjet-printer-201202w-1.0.0-1lsb3.2.src.rpm"
      ];

      hash = "sha256-Rq3vDVJolFB+Yi2OiJbT7Lrf+yhJMdfbxGwGYqUNzY0=";
    };

    nativeBuildInputs = [ rpmextract autoreconfHook file ];

    buildInputs = [ libjpeg cups ];

    unpackPhase = ''
      rpmextract $src
      tar -zxf epson-inkjet-printer-201202w-${version}.tar.gz
      tar -zxf epson-inkjet-printer-filter-${filterVersion}.tar.gz
      for ppd in epson-inkjet-printer-201202w-${version}/ppds/*; do
        substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-201202w" "$out"
        substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
      done
      cd epson-inkjet-printer-filter-${filterVersion}
    '';

    preConfigure = ''
      chmod +x configure
      export LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
    '';

    postInstall = ''
      cd ../epson-inkjet-printer-201202w-${version}
      cp -a lib64 resource watermark $out
      mkdir -p $out/share/cups/model/epson-inkjet-printer-201202w
      cp -a ppds $out/share/cups/model/epson-inkjet-printer-201202w/
      cp -a Manual.txt $out/doc/
      cp -a README $out/doc/README.driver
    '';

    meta = with lib; {
      homepage = "https://www.openprinting.org/driver/epson-201202w";
      description = "Epson printer driver (XP-102 103 Series, XP-202 203 206 Series, XP-205 207 Series, XP-30 33 Series)";
      longDescription = ''
        This software is a filter program used with the Common UNIX Printing
        System (CUPS) under Linux. It supplies high quality printing with
        Seiko Epson Color Ink Jet Printers.
        List of printers supported by this package:
          Epson XP-102 Series
          Epson XP-103 Series
          Epson XP-202 Series
          Epson XP-203 Series
          Epson XP-206 Series
          Epson XP-205 Series
          Epson XP-207 Series
          Epson XP-30 Series
          Epson XP-33 Series
        To use the driver adjust your configuration.nix file:
          services.printing = {
            enable = true;
            drivers = [ pkgs.epson-201202w ];
          };
      '';
      license = with licenses; [ lgpl21 epson ];
      platforms = platforms.linux;
      maintainers = with maintainers; [ nphilou ];
    };
  }
