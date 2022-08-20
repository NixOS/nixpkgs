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
    , lib
    , perl
    , stdenvNoCC
    , zlib
    }:

    stdenvNoCC.mkDerivation rec {
      pname = "coreboot-toolchain-${arch}";
      version = "4.16";

      src = fetchgit {
        url = "https://review.coreboot.org/coreboot";
        rev = version;
        sha256 = "sha256-PCum+IvJ136eZQLovUi9u4xTLLs17MkMP5Oc0/2mMY4=";
        fetchSubmodules = false;
        leaveDotGit = true;
        postFetch = ''
          PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
          rm -rf $out/.git
        '';
        allowedRequisites = [ ];
      };

      nativeBuildInputs = [ bison curl git perl ];
      buildInputs = [ flex gnat11 zlib ];

      enableParallelBuilding = true;
      dontConfigure = true;
      dontInstall = true;

      postPatch = ''
        patchShebangs $out/util/crossgcc/buildgcc

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

lib.listToAttrs (map (arch: lib.nameValuePair arch (common arch {})) [
  "i386"
  "x64"
  "arm"
  "aarch64"
  "riscv"
  "ppc64"
  "nds32le"
])
