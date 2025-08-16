{
  bc,
  bison,
  buildPackages,
  darwin,
  fetchurl,
  flex,
  gnutls,
  installShellFiles,
  lib,
  libuuid,
  ncurses,
  openssl,
  perl,
  python3,
  stdenv,
  swig,
  which,
}:

let
  # Dependencies for the tools need to be included as either native or cross,
  # depending on which we're building
  toolsDeps = [
    ncurses # tools/kwboot
    libuuid # tools/mkeficapsule
    gnutls # tools/mkeficapsule
    openssl # tools/mkimage and tools/env/fw_printenv
  ];
in
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "extraMeta"
    "pythonScriptsToInstall"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      crossTools ? false,
      defconfig,
      extraConfig ? "",
      filesToInstall,
      installDir ? "$out",
      pythonScriptsToInstall ? { },
      ...
    }@args:
    {
      pname = "uboot-${defconfig}";

      version = args.version or "2025.07";
      src = args.src or fetchurl {
        url = "https://ftp.denx.de/pub/u-boot/u-boot-${finalAttrs.version}.tar.bz2";
        hash = "sha256-D5M/bFpCaJW/MG6T5qxTxghw5LVM2lbZUhG+yZ5jvsc=";
      };

      patches =
        (args.patches or [ ])
        ++ (lib.warnIf (args ? extraPatches)
          "buildUBoot now accepts `patches`, please switch from using `extraPatches` to `patches`"
          args.extraPatches or [ ]
        );

      postPatch = ''
        ${lib.concatMapStrings (script: ''
          substituteInPlace ${script} \
            --replace-fail "#!/usr/bin/env python3" "#!${pythonScriptsToInstall.${script}}/bin/python3"
        '') (builtins.attrNames pythonScriptsToInstall)}
        patchShebangs tools
        patchShebangs scripts
      '';

      nativeBuildInputs = [
        ncurses # tools/kwboot
        bc
        bison
        flex
        installShellFiles
        (python3.pythonOnBuildForHost.withPackages (p: [
          p.libfdt
          p.setuptools # for pkg_resources
          p.pyelftools
        ]))
        swig
        which # for scripts/dtc-version.sh
        perl # for old build (secureboot)
      ]
      ++ lib.optionals (!crossTools) toolsDeps
      ++ lib.optionals stdenv.buildPlatform.isDarwin [ darwin.DarwinTools ]; # sw_vers command is needed on darwin
      depsBuildBuild = [ buildPackages.gccStdenv.cc ]; # gccStdenv is needed for Darwin buildPlatform
      buildInputs = lib.optionals crossTools toolsDeps;

      hardeningDisable = [ "all" ];

      enableParallelBuilding = true;

      makeFlags = [
        "DTC=${lib.getExe buildPackages.dtc}"
        "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
        "HOSTCFLAGS=-fcommon"
      ]
      ++ (args.makeFlags or [ ])
      ++ (lib.warnIf (args ? extraMakeFlags)
        "buildUBoot now accepts `makeFlags`, please switch from using `extraMakeFlags` to `makeFlags`"
        args.extraMakeFlags or [ ]
      );

      inherit extraConfig;
      passAsFile = [ "extraConfig" ];

      configurePhase = ''
        runHook preConfigure

        make -j$NIX_BUILD_CORES ${defconfig}

        cat $extraConfigPath >> .config

        runHook postConfigure
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p ${installDir}
        cp ${
          lib.concatStringsSep " " (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)
        } ${installDir}

        mkdir -p "$out/nix-support"
        ${lib.concatMapStrings (file: ''
          echo "file binary-dist ${installDir}/${builtins.baseNameOf file}" >> "$out/nix-support/hydra-build-products"
        '') (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)}

        runHook postInstall
      '';

      dontStrip = true;

      meta = {
        homepage = "https://www.denx.de/wiki/U-Boot/";
        description = "Boot loader for embedded systems";
        license = lib.licenses.gpl2Plus;
        maintainers = with lib.maintainers; [
          dezgeg
          lopsided98
        ];
      }
      // (args.meta or { })
      // (lib.warnIf (args ? extraMeta)
        "buildUBoot now accepts `meta`, please switch from using `extraMeta` to `meta`"
        args.extraMeta or { }
      );
    };
}
