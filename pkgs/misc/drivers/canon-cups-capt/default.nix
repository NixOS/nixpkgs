{ stdenv, callPackage,
  tree
}:

let
  common = callPackage ./common.nix {};
  capt = callPackage ./capt.nix { cndrvcups-common = common;};
  doc = callPackage ./doc.nix {};
in
  stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "capt-driverpack";
    version = "2.71";

    src = null;

    patches = [ ./0002-add-ccpd-service.patch ];

    buildInputs = [
      common capt doc
      tree
    ];

    # install directions based on arch PKGBUILD file
    # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

    phases = [ "patchPhase" "installPhase" ];

    installPhase = ''
      set -ex

      mkdir -p $out

      ##NOTE: list output of `common` and `capt` for debugging
      tree ${common} > $out/common_build.log
      tree ${capt} > $out/capt_build.log
      tree ${doc} > $out/doc_build.log

      ##TODO: check how Nix's systemd works
      ## Installation of the custom Arch Linux CCPD systemd service
      substituteInPlace ccpd.service \
        --replace ExecStart=/usr/bin/ccpd ExecStart=${capt}/bin/ccpd

      install -dm755 $out/lib/systemd/system/
      install -Dm664 ccpd.service $out/lib/systemd/system/ccpd.service

      ###################################################################
      ##FIXME: the problematic code collected here to be able to cache `capt.nix` build
      ##       move the corresponding line back to where is should belong

      ##FIXME: stuck with invalid group `lp`
      # install -dm750 -o root -g lp $out/var/captmon/

      ##FIXME: how to install a ppd to cups?, need to?
      ##       capt's ppd files are in ${capt}/share/cups/model
      # install -dm755 $out/share/ppd/cupsfilters/
      # for _f in ${capt}/share/cups/model/CN*CAPT*.ppd; do
      #   ln -s $_f $out/share/ppd/cupsfilters
      # done
    '';

    meta = with stdenv.lib; {
      description = "Canon CAPT driver pack";
      homepage = https://global.canon;
      maintainers = [ maintainers.wizzup ];
      platforms = platforms.linux;

      #NOTE: desc taken from : https://th.canon/th/support/0100459601/7
      longDescription = ''
        This CAPT printer driver provides printing functions for Canon LBP printers operating under the CUPS (Common Unix Printing System) environment, a printing system that functions on Linux operating systems.
      '';

      #FIXME: not sure about license
      #       https://th.canon/en/support/0100459601/7
      # license = licenses.gpl3Plus;
    };

  }
