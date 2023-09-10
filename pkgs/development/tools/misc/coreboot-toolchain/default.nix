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
    , gnat11
    , gcc
    , lib
    , perl
    , stdenvNoCC
    , zlib
    , withAda ? true
    }:

    stdenvNoCC.mkDerivation {
      pname = "coreboot-toolchain-${arch}";
      version = "4.21";

      src = fetchgit {
        url = "https://review.coreboot.org/coreboot";
        rev = "c1386ef6128922f49f93de5690ccd130a26eecf2";
        hash = "sha256-tFGyI170vbhRgJZDix69DfOD5nIY8T4chSP+qTt3kC8=";
        fetchSubmodules = false;
        leaveDotGit = true;
        postFetch = ''
          PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
          rm -rf $out/.git
        '';
        allowedRequisites = [ ];
      };

      nativeBuildInputs = [ bison curl git perl ];
      buildInputs = [ flex zlib (if withAda then gnat11 else gcc) ];

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
        maintainers = with maintainers; [ felixsinger ];
        platforms = platforms.linux;
      };
    }
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
