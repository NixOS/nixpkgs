{
  lib,
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  fetchFromCodeberg,
  libgcrypt,
  lvm2,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "shufflecake";
  version = "0.6.2";

  src = fetchFromCodeberg {
    owner = "shufflecake";
    repo = "shufflecake-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Hrejg+9CwTWlcRnJ0fBAsiaQoxBuOSvlC+gFEFw2rVA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [
    libgcrypt
    lvm2
  ];
  makeFlags =
    kernelModuleMakeFlags
    ++ [
      "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ]
    # Use wrapped gcc compiler since the unwrapped one fails to find the
    # headers.
    ++ lib.optionals stdenv.cc.isGNU [
      "CC=${stdenv.cc.targetPrefix}cc"
    ];

  outputs = [
    "out"
    "bin"
  ];

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD/dm-sflc \
      INSTALL_MOD_PATH=$out \
      $makeFlags \
      modules_install

    mkdir -p $bin/bin
    install -Dm555 sflc/build/bin/sflc $bin/bin/sflc
    # v0.6 provides an alias for pre-v0.6 compatibility
    ln -s sflc $bin/bin/shufflecake
  '';

  passthru.tests = { inherit (nixosTests) shufflecake; };

  meta = {
    description = "Plausible deniability (hidden storage) layer for Linux";
    homepage = "https://shufflecake.net";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ oluceps ];
    outputsToInstall = [ "bin" ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.1" || kernel.meta.name == "linux-lqx-6.12.1";
  };
})
