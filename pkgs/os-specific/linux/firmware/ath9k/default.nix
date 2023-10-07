{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, m4
, cmake
, perl
, writeScript
, enableUnstable ? false
}:

let
  stableVersion = "1.4.0";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ath9k-htc-blobless-firmware";
  version = if enableUnstable then "unstable-2022-05-22" else stableVersion;

  src = fetchFromGitHub ({
    owner = "qca";
    repo = "open-ath9k-htc-firmware";
  } // (if enableUnstable then {
    rev = "d856466a068afe4069335257c0d28295ff777d92";
    hash = "sha256-9OE6qYGABeXjf1r/Depd+811EJ2e8I0Ni5ePHSOh9G4=";
  } else {
    rev = finalAttrs.version;
    hash = "sha256-Q/A0ryIC5E1pt2Sh7o79gxHbe4OgdlrwflOWtxWSS5o=";
  }));

  postPatch = ''
    patchShebangs target_firmware/firmware-crc.pl
  '';

  nativeBuildInputs = [ m4 cmake perl ];

  env.NIX_CFLAGS_COMPILE = "-w";  # old libiberty emits fatal warnings

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  # The firmware repository builds its own toolchain, with patches
  # applied to the xtensa support in both gcc and binutils.
  preBuild =
    let
      inherit (lib) toUpper splitString last listToAttrs pipe;
      inherit (builtins) map;
      urls-and-hashes = import (./. + "/urls-and-hashes-${finalAttrs.version}.nix");
      make-links = pipe
        [ "gcc" "binutils" "gmp" "mpfr" "mpc" ]
        [ (map (vname: fetchurl rec {
            url = urls-and-hashes."${(toUpper vname) + "_URL"}";
            sha256 = urls-and-hashes."${(toUpper vname) + "_SUM"}" or "";
            name = last (splitString "/" url);
          }))
          (map (v: "ln -sT ${v} toolchain/dl/${v.name}"))
          (lib.concatStringsSep "\n")
        ];
    in ''
      mkdir -p toolchain/dl
      ${make-links}
    '';

  makeTargets = [ "toolchain" "firmware" ];

  installPhase = ''
    runHook preInstall
    install -Dt "$out/lib/firmware/ath9k_htc/" target_firmware/*.fw
    # make symlinks so that firmware will be automatically found
    ln -s htc_7010.fw "$out/lib/firmware/ath9k_htc/htc_7010-${stableVersion}.fw"
    ln -s htc_9271.fw "$out/lib/firmware/ath9k_htc/htc_9271-${stableVersion}.fw"
    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) src;
    updateScript = writeScript "${finalAttrs.pname}-${finalAttrs.version}-updateScript" ''
      nix-shell '<nixpkgs>' -A ${finalAttrs.pname}${lib.optionalString enableUnstable "-unstable"}.passthru.update \
      > pkgs/os-specific/linux/firmware/ath9k/urls-and-hashes-${finalAttrs.version}.nix
    '';
    update = stdenv.mkDerivation {
      name = "${finalAttrs.pname}-${finalAttrs.version}-update";
      shellHook = ''
        echo 'rec {'
        echo '  BASEDIR="$NIX_BUILD_TOP";'
        make --dry-run --print-data-base -f ${finalAttrs.src}/Makefile download \
          | egrep    '^[A-Z]+_(VER|URL|SUM|DIR) = ' \
          | sed 's_\([^ ]*\) = \(.*\)_\1 = "\2\";_' \
          | tr \( \{ \
          | tr \) \}
      ''
      # sha256 checksums were not added to upstream's Makefile until
      # after the 1.4.0 release.  The following line is needed for
      # the `enableUnstable==false` build but not for the
      # `enableUnstable==true` build.  We can remove the lines below
      # as soon as `enableUnstable==false` points to a version
      # greater than 1.4.0.
      + lib.optionalString (finalAttrs.version == "1.4.0") ''
        echo 'GCC_SUM = "sha256-kuYcbcOgpEnmLXKjgYX9pVAWioZwLeoHEl69PsOZYoI=";'
        echo 'MPFR_SUM = "sha256-e2bD8T3IOF8IJkyAWFPz4aju2rgHHVgvPmYZccms1f0=";'
        echo 'MPC_SUM = "sha256-7VqBXP6lJdx3jfDLN0aLnBtVSq8w2TKLFDHKcFt0AP8=";'
        echo 'GMP_SUM = "sha256-H1iKrMxBu5rtlG+f44Uhwm2LKQ0APF34B/ZWkPKq3sk=";'
        echo 'BINUTILS_SUM = "sha256-KrLlsD4IbRLGKV+DGtrUaz4UEKOiNJM6Lo+sZssuehk=";'
      '' + ''
        echo '}'
        exit
      '';
    };
  };

  meta = {
    description = "Blobless, open source wifi firmware for ath9k_htc.ko";
    longDescription = ''
      Firmware for Qualcomm Atheros cards which use the ath9k_htc.ko
      Linux driver, supporting 802.11 abgn on both 2.4ghz and 5ghz
      bands, 3x3-antenna MIMO, up to 600mbit/sec.

      Most devices which use this driver are based on the Qualcomm
      Atheros AR9271 chip, which is a PCIe device.  If your device
      is connected via USB, it will also include a Qualcomm Atheros
      AR7010, which bridges from a USB gadget interface to a PCIe
      host interface.  This repository includes the firmware for
      both chips.

      This firmware is completely open source with no blobs, which
      is quite rare in the wifi world.  Wifi chips have their own
      dedicated general-purpose CPUs.  This source code allows you
      to see what those CPUs are doing and modify their behavior.
    '';
    license = with lib.licenses; [ # see NOTICE.txt for details
      bsd3                # almost everything; "the ClearBSD licence"
      gpl2ClasspathPlus   # **/*cmnos_printf.c, only three files
      mit                 # **/xtos, **/xtensa
    ];

    # release 1.4.0 vendors a GMP which uses an ancient version of
    # autotools that does not work on aarch64 or powerpc.
    # However, enableUnstable (unreleased upstream) works.
    /*
    # disabled until #195294 is merged
    badPlatforms =
      with lib.systems.inspect.patterns;
      lib.optionals (!enableUnstable && lib.versionOlder finalAttrs.version "1.4.1") [
        isAarch64
        isPower64
      ];
    */

    sourceProvenance = [ lib.sourceTypes.fromSource ];
    homepage = "http://lists.infradead.org/mailman/listinfo/ath9k_htc_fw";
    downloadPage = "https://github.com/qca/open-ath9k-htc-firmware";
    changelog = "https://github.com/qca/open-ath9k-htc-firmware/tags";
  };
})
