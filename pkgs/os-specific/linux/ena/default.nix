{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  version = "2.8.6";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    hash = "sha256-clRu+ecK/Je0kvlAAm6qCJqMyvZv0C88YIGDImhRhKA=";
  };

  patches =
    [ # https://github.com/amzn/amzn-drivers/issues/269#issuecomment-1552483792
      (fetchpatch {
        url = "https://github.com/amzn/amzn-drivers/files/11504862/phc_kernel_6_2_fix.patch";
        hash = "sha256-/EBkISwXMd7t4WZjsG9KVP6vncFwcZq1QBsxQLXyWsY=";
      })
      # https://github.com/amzn/amzn-drivers/issues/270#issuecomment-1561924754
      (fetchpatch {
        url = "https://github.com/amzn/amzn-drivers/files/11559312/devlink_6_2_fix.patch";
        hash = "sha256-Nc71u91G0dL+ld6ovqjHaE6X2TxduWeQYr5K0KdoA3Q=";
      })
      (fetchpatch {
        url = "https://github.com/amzn/amzn-drivers/files/11559314/devlink_6_3_fix.patch";
        hash = "sha256-aEQTbwHC1DcDrtj188eoGzi3GU9MXnwIxuJW4L7qb/I=";
      })
    ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  # linux 3.12
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    export ENA_PHC_INCLUDE=1
    substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    $STRIP -S ena.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp ena.ko $dest/
    xz $dest/ena.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ eelco sielicki ];
    platforms = platforms.linux;
  };
}
