{ stdenv, lib, callPackage }:
let
  common = arch: callPackage (
    { bison
    , callPackage
    , curl
    , fetchgit
    , flex
    , getopt
    , git
    , gnat
    , gcc
    , lib
    , perl
    , stdenvNoCC
    , zlib
    , withAda ? true
    }:

    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "coreboot-toolchain-${arch}";
      version = "24.05";

      src = fetchgit {
        url = "https://review.coreboot.org/coreboot";
        rev = finalAttrs.version;
        hash = "sha256-jTfMFvl3sG3BIVVkpZ81BQ20Bs+2ESE6RMh0fW86rKE=";
        fetchSubmodules = false;
        leaveDotGit = true;
        postFetch = ''
          PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
          rm -rf $out/.git
        '';
        allowedRequisites = [ ];
      };

      nativeBuildInputs = [ bison curl git perl ];
      buildInputs = [ flex zlib (if withAda then gnat else gcc) ];

      enableParallelBuilding = true;
      dontConfigure = true;
      dontInstall = true;

      postPatch = ''
        patchShebangs util/crossgcc/buildgcc

        mkdir -p util/crossgcc/tarballs

        ${lib.concatMapStringsSep "\n" (
          file: "ln -s ${file.archive} util/crossgcc/tarballs/${file.name}"
          ) (callPackage ./stable.nix { })
        }

        patchShebangs util/genbuild_h/genbuild_h.sh
      '';

      buildPhase = ''
        export CROSSGCC_VERSION=$(cat .crossgcc_version)
        make crossgcc-${arch} CPUS=$NIX_BUILD_CORES DEST=$out
      '';

      meta = with lib; {
        homepage = "https://www.coreboot.org";
        description = "coreboot toolchain for ${arch} targets";
        license = with licenses; [ bsd2 bsd3 gpl2 lgpl2Plus gpl3Plus ];
        maintainers = with maintainers; [ felixsinger jmbaur ];
        platforms = platforms.linux;
      };
    })
  );
in

lib.listToAttrs (map (arch: lib.nameValuePair arch (common arch { })) [
  "i386"
  "x64"
  "arm"
  "aarch64"
  "riscv"
  "ppc64"
  "nds32le"
])
