{
  stdenv,
  lib,
  callPackage,
}:
let
  common =
    arch:
    callPackage (
      {
        bison,
        callPackage,
        curl,
        fetchgit,
        flex,
        getopt,
        git,
        gnat14,
        gcc14,
        lib,
        perl,
        stdenvNoCC,
        zlib,
        withAda ? true,
      }:

      stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "coreboot-toolchain-${arch}";
        version = "25.12";

        src = fetchgit {
          url = "https://review.coreboot.org/coreboot";
          rev = finalAttrs.version;
          hash = "sha256-zm1M+iveBxE/8/vIXZz1KoFkMaKW+bsQM4me5T6WqVY=";
          fetchSubmodules = false;
          leaveDotGit = true;
          postFetch = ''
            PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
            rm -rf $out/.git
          '';
        };

        archives = ./stable.nix;

        nativeBuildInputs = [
          bison
          curl
          git
          perl
        ];
        buildInputs = [
          flex
          zlib
          (if withAda then gnat14 else gcc14)
        ];

        enableParallelBuilding = true;
        dontConfigure = true;
        dontInstall = true;

        postPatch = ''
          patchShebangs util/crossgcc/buildgcc

          mkdir -p util/crossgcc/tarballs

          ${lib.concatMapStringsSep "\n" (file: "ln -s ${file.archive} util/crossgcc/tarballs/${file.name}") (
            callPackage finalAttrs.archives { }
          )}

          patchShebangs util/genbuild_h/genbuild_h.sh
        '';

        buildPhase = ''
          export CROSSGCC_VERSION=$(cat .crossgcc_version)
          make crossgcc-${arch} CPUS=$NIX_BUILD_CORES DEST=$out
        '';

        meta = {
          homepage = "https://www.coreboot.org";
          description = "Coreboot toolchain for ${arch} targets";
          license = with lib.licenses; [
            bsd2
            bsd3
            gpl2
            lgpl2Plus
            gpl3Plus
          ];
          maintainers = with lib.maintainers; [
            felixsinger
            jmbaur
          ];
          platforms = lib.platforms.linux;
        };
      })
    );
in

lib.listToAttrs (
  map (arch: lib.nameValuePair arch (common arch { })) [
    "i386"
    "x64"
    "arm"
    "aarch64"
    "riscv"
    "ppc64"
  ]
)
