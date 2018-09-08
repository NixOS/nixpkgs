{ stdenv, fetchurl, cups, pkgsi686Linux, dpkg, psutils, makeWrapper, ghostscript, bash }:

let
  version = "1.2-0";

  libstdcpp5 = fetchurl {
    url = "http://old-releases.ubuntu.com/ubuntu/pool/universe/g/gcc-3.3/libstdc++5_3.3.6-17ubuntu1_i386.deb";
    sha256 = "10f8zcmqaa7skvg2bz94mnlgqpan4iscvi8913r6iawjh7hiisjy";
  };
in
  stdenv.mkDerivation {
    name = "epson-alc1100-${version}";

    src = fetchurl {
      url = "http://a1227.g.akamai.net/f/1227/40484/7d/download.ebz.epson.net/dsc/f/01/00/01/58/65/cd71929d2bf41ebf7e96f68fa9f1279556545ef1/Epson-ALC1100-filter-1.2.tar.gz";
      sha256 = "0q0bf4dfm4v69l7xg6sgkh7rwb0h77i8j9kplq1dfkd208g7y81p";
    };

    patches = [ ./cups-data-dir.patch ./ppd.patch ];

    nativeBuildInputs = [ dpkg makeWrapper ];

    buildInputs = [ cups pkgsi686Linux.glibc psutils ghostscript bash ];

    postUnpack = ''
      dpkg -x ${libstdcpp5} libstdcpp5_i386;

      mkdir -p $out/lib;

      mv libstdcpp5_i386/usr/lib/* $out/lib;
    '';

    postFixup = ''
      patchelf --set-interpreter ${pkgsi686Linux.glibc}/lib/ld-linux.so.2 \
        --set-rpath "${stdenv.lib.makeLibraryPath [
          pkgsi686Linux.glibc
          "$out"
        ]}" $out/bin/alc1100

      patchelf --set-rpath "${stdenv.lib.makeLibraryPath [
          pkgsi686Linux.glibc
        ]}" $out/lib/libstdc++.so.5.0.7

      wrapProgram $out/bin/alc1100_lprwrapper.sh \
        --suffix PATH : "\$PATH:${psutils}/bin:/var/lib/cups/path/bin"

      wrapProgram $out/bin/pstoalc1100.sh \
        --suffix PATH : "\$PATH:${psutils}/bin:${ghostscript}/bin:${bash}/bin:/var/lib/cups/path/bin"
    '';

    meta = with stdenv.lib; {
      homepage = http://download.ebz.epson.net/dsc/search/01/search/;
      description = "Epson AcuLaser C1100 Driver";
      longDescription = ''
        This package provides a print filter for printing to EPSON AL-C1100
        printers on Linux systems.

        To use the driver adjust your configuration.nix file:
          services.printing = {
            enable = true;
            drivers = [ pkgs.epson-alc1100 ];
          };
      '';

      license = with licenses; [ mit eapl ];
      maintainers = [ maintainers.eperuffo ];
      platforms = platforms.linux;
    };

  }
