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
<<<<<<< HEAD
        version = "25.09";
=======
        version = "25.03";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

        src = fetchgit {
          url = "https://review.coreboot.org/coreboot";
          rev = finalAttrs.version;
<<<<<<< HEAD
          hash = "sha256-GMLhGspaS+SsldYFwhMoxzpFgU6alm6WASv3lp/FRRY=";
=======
          hash = "sha256-zyfBQKVton+2vjYd6fqrUqkHY9bci411pujRGabvTjQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          fetchSubmodules = false;
          leaveDotGit = true;
          postFetch = ''
            PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
            rm -rf $out/.git
          '';
          allowedRequisites = [ ];
        };

<<<<<<< HEAD
        archives = ./stable.nix;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
            callPackage finalAttrs.archives { }
=======
            callPackage ./stable.nix { }
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          )}

          patchShebangs util/genbuild_h/genbuild_h.sh
        '';

        buildPhase = ''
          export CROSSGCC_VERSION=$(cat .crossgcc_version)
          make crossgcc-${arch} CPUS=$NIX_BUILD_CORES DEST=$out
        '';

<<<<<<< HEAD
        meta = {
          homepage = "https://www.coreboot.org";
          description = "Coreboot toolchain for ${arch} targets";
          license = with lib.licenses; [
=======
        meta = with lib; {
          homepage = "https://www.coreboot.org";
          description = "Coreboot toolchain for ${arch} targets";
          license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
            bsd2
            bsd3
            gpl2
            lgpl2Plus
            gpl3Plus
          ];
<<<<<<< HEAD
          maintainers = with lib.maintainers; [
            felixsinger
            jmbaur
          ];
          platforms = lib.platforms.linux;
=======
          maintainers = with maintainers; [
            felixsinger
            jmbaur
          ];
          platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
