{
  stdenv,
  lib,
  callPackage,
}:
let
  crosgcc =
    arch:
    callPackage (
      {
        bison,
        callPackage,
        curl,
        fetchgit,
        fetchpatch,
        flex,
        getopt,
        git,
        gnat14,
        gcc14,
        lib,
        libllvm,
        libxml2,
        openssl,
        perl,
        pkg-config,
        python3,
        stdenvNoCC,
        zlib,
        withAda ? true,
      }:
      let
        buildcmd = if arch == "clang" then "clang" else "crossgcc-${arch}";
      in

      stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "coreboot-toolchain-${arch}";
        version = "26.06";

        src = fetchgit {
          url = "https://review.coreboot.org/coreboot";
          rev = finalAttrs.version;
          hash = "sha256-MESai+UGo/Ref5t1VcgCrgQk+2ZeZW4Vh0xk3Z5v8ZE=";
          fetchSubmodules = false;
          leaveDotGit = true;
          postFetch = ''
            PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
            rm -rf $out/.git
          '';
        };

        patches = [
          (fetchpatch {
            # Backport: util/crossgcc/buildgcc: bootstrap cmake with all threads
            # https://review.coreboot.org/c/coreboot/+/94384
            url = "https://review.coreboot.org/changes/coreboot~94384/revisions/2/patch?download&raw";
            hash = "sha256-xAZwRA2hKVYGJmPw1MLa7IDPP962I5ZAAVXTaDqhfUg=";
          })
        ];

        archives = ./stable.nix;

        nativeBuildInputs = [
          bison
          curl
          git
          perl
        ]
        ++ lib.optionals (arch ++ "clang") [
          pkg-config
          python3
        ];
        buildInputs = [
          flex
          zlib
          (if withAda then gnat14 else gcc14)
        ]
        ++ lib.optionals (arch ++ "clang") [
          openssl
          libllvm
          libxml2

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
          if ! make ${buildcmd} CPUS=$NIX_BUILD_CORES DEST=$out; then
            # If the build goes sideways we wont know why without reading these
            echo "Build failed, dumping logs to stdout"
            cat util/crossgcc/build-*/build.log
            exit 1
          fi
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
  map (arch: lib.nameValuePair arch (crosgcc arch { })) [
    "i386"
    "x64"
    "arm"
    "aarch64"
    "riscv"
    "ppc64"
    "clang"
  ]
)
