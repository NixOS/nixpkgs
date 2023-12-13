{ lib, stdenv, fetchurl, cups, pkgsi686Linux, dpkg, psutils, makeWrapper, ghostscript, bash }:

let
  version = "1.2-0";

  libstdcpp5 = fetchurl {
    url = "mirror://ubuntu/pool/universe/g/gcc-3.3/libstdc++5_3.3.6-17ubuntu1_i386.deb";
    sha256 = "10f8zcmqaa7skvg2bz94mnlgqpan4iscvi8913r6iawjh7hiisjy";
  };
in
  stdenv.mkDerivation {
    pname = "epson-alc1100";
    inherit version;

    src = fetchurl {
      url = "https://download3.ebz.epson.net/dsc/f/03/00/11/33/07/4027e99517b5c388d444b8444d719b4b77f7e9db/Epson-ALC1100-filter-1.2.tar.gz";
      sha256 = "1dfw75a3kj2aa4iicvlk9kz3jarrsikpnpd4cdpw79scfc5mwm2p";
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
        --set-rpath "${lib.makeLibraryPath [
          pkgsi686Linux.glibc
          "$out"
        ]}" $out/bin/alc1100

      patchelf --set-rpath "${lib.makeLibraryPath [
          pkgsi686Linux.glibc
        ]}" $out/lib/libstdc++.so.5.0.7

      wrapProgram $out/bin/alc1100_lprwrapper.sh \
        --suffix PATH : "\$PATH:${psutils}/bin:/var/lib/cups/path/bin"

      wrapProgram $out/bin/pstoalc1100.sh \
        --suffix PATH : "\$PATH:${psutils}/bin:${ghostscript}/bin:${bash}/bin:/var/lib/cups/path/bin"
    '';

    meta = with lib; {
      homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
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

      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = with licenses; [ mit eapl ];
      maintainers = [ maintainers.eperuffo ];
      platforms = platforms.linux;
    };

  }
