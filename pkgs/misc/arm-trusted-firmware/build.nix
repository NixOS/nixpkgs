{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkgsCross
, buildPackages
}:

{ filesToInstall
, installDir ? "$out"
, platform ? null
, deleteHDCPBlobBeforeBuild ? false
, extraMakeFlags ? []
, extraMeta ? {}
, version ? "2.6"
, ... } @ args:

stdenv.mkDerivation ({

  pname = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ARM-software";
    repo = "arm-trusted-firmware";
    rev = "v${version}";
    sha256 = "sha256-qT9DdTvMcUrvRzgmVf2qmKB+Rb1WOB4p1rM+fsewGcg=";
  };

  patches = lib.optionals deleteHDCPBlobBeforeBuild [
    # this is a rebased version of https://gitlab.com/vicencb/kevinboot/-/blob/master/atf.patch
    ./remove-hdcp-blob.patch
  ];

  postPatch = lib.optionalString deleteHDCPBlobBeforeBuild ''
      rm plat/rockchip/rk3399/drivers/dp/hdcp.bin
    '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # For Cortex-M0 firmware in RK3399
  nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

  buildInputs = [ openssl ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ (lib.optional (platform != null) "PLAT=${platform}")
  ++ extraMakeFlags;

  installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

  hardeningDisable = [ "all" ];
  dontStrip = true;

  # Fatal error: can't create build/sun50iw1p1/release/bl31/sunxi_clocks.o: No such file or directory
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://github.com/ARM-software/arm-trusted-firmware";
    description = "A reference implementation of secure world software for ARMv8-A";
    license = [ licenses.bsd3 ] ++ lib.optionals (!deleteHDCPBlobBeforeBuild) [ licenses.unfreeRedistributable ];
    maintainers = with maintainers; [ lopsided98 ];
  } // extraMeta;
} // builtins.removeAttrs args [ "extraMeta" ])
