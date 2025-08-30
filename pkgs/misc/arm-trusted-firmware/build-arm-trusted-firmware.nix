{
  buildPackages,
  fetchFromGitHub,
  lib,
  openssl,
  pkgsCross,
  stdenv,

  # Warning: this blob (hdcp.bin) runs on the main CPU (not the GPU) at
  # privilege level EL3, which is above both the kernel and the
  # hypervisor.
  #
  # This parameter applies only to platforms which are believed to use
  # hdcp.bin. On all other platforms, or if unfreeIncludeHDCPBlob=false,
  # hdcp.bin will be deleted before building.
  unfreeIncludeHDCPBlob ? true,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [ "extraMeta" ];

  extendDrvArgs =
    finalAttrs:
    {
      filesToInstall,
      installDir ? "$out",
      platform ? null,
      platformCanUseHDCPBlob ? false, # set this to true if the platform is able to use hdcp.bin
      ...
    }@args:

    # delete hdcp.bin if either: the platform is thought to
    # not need it or unfreeIncludeHDCPBlob is false
    let
      deleteHDCPBlobBeforeBuild = !platformCanUseHDCPBlob || !unfreeIncludeHDCPBlob;
    in
    {
      pname = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}";
      version = args.version or "2.13.0";

      src =
        args.src or (fetchFromGitHub {
          owner = "ARM-software";
          repo = "arm-trusted-firmware";
          tag = "v${finalAttrs.version}";
          hash = "sha256-rxm5RCjT/MyMCTxiEC8jQeFMrCggrb2DRbs/qDPXb20=";
        });

      patches =
        lib.optionals deleteHDCPBlobBeforeBuild [
          # this is a rebased version of https://gitlab.com/vicencb/kevinboot/-/blob/master/atf.patch
          ./remove-hdcp-blob.patch
        ]
        ++ args.patches or [ ];

      postPatch =
        lib.optionalString deleteHDCPBlobBeforeBuild ''
          rm plat/rockchip/rk3399/drivers/dp/hdcp.bin
        ''
        + args.postPatch or "";

      depsBuildBuild = [ buildPackages.stdenv.cc ] ++ args.depsBuildBuild or [ ];

      nativeBuildInputs = [
        pkgsCross.arm-embedded.stdenv.cc # For Cortex-M0 firmware in RK3399
        openssl # For fiptool
      ]
      ++ args.nativeBuildInputs or [ ];

      # Make the new toolchain guessing (from 2.11+) happy
      # https://github.com/ARM-software/arm-trusted-firmware/blob/4ec2948fe3f65dba2f19e691e702f7de2949179c/make_helpers/toolchains/rk3399-m0.mk#L21-L22
      rk3399-m0-oc = "${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}objcopy";

      buildInputs = [ openssl ] ++ args.buildInputs or [ ];

      makeFlags = [
        "HOSTCC=$(CC_FOR_BUILD)"
        "M0_CROSS_COMPILE=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
        "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
        # Make the new toolchain guessing (from 2.11+) happy
        "CC=${stdenv.cc.targetPrefix}cc"
        "LD=${stdenv.cc.targetPrefix}cc"
        "AS=${stdenv.cc.targetPrefix}cc"
        "OC=${stdenv.cc.targetPrefix}objcopy"
        "OD=${stdenv.cc.targetPrefix}objdump"
        # Passing OpenSSL path according to docs/design/trusted-board-boot-build.rst
        "OPENSSL_DIR=${openssl}"
      ]
      ++ (lib.optional (platform != null) "PLAT=${platform}")
      ++ args.makeFlags or [ ]
      ++ (lib.warnIf (args ? extraMakeFlags)
        "buildArmTrustedFirmware now accepts `makeFlags`, please switch from using `extraMakeFlags` to `makeFlags`"
        args.extraMakeFlags or [ ]
      );

      installPhase = ''
        runHook preInstall

        mkdir -p ${installDir}
        cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

        runHook postInstall
      '';

      hardeningDisable = [ "all" ];
      dontStrip = true;

      # breaks secondary CPU bringup on at least RK3588, maybe others
      env.NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

      meta = {
        homepage = "https://github.com/ARM-software/arm-trusted-firmware";
        description = "Reference implementation of secure world software for ARMv8-A";
        license = [
          lib.licenses.bsd3
        ]
        ++ lib.optionals (!deleteHDCPBlobBeforeBuild) [ lib.licenses.unfreeRedistributable ];
        maintainers = [ lib.maintainers.lopsided98 ];
      }
      // (args.meta or { })
      // (lib.warnIf (args ? extraMeta)
        "buildArmTrustedFirmware now accepts `meta`, please switch from using `extraMeta` to `meta`"
        args.extraMeta or { }
      );
    };
}
