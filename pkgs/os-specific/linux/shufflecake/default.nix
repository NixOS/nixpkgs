{
  lib,
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  fetchFromCodeberg,
  libgcrypt,
  lvm2,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "shufflecake";
  version = "0.5.8";

  src = fetchFromCodeberg {
    owner = "shufflecake";
    repo = "shufflecake-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eI5tWujUHj9S8d1aOFMuokjVWI2GGEml68cuQ6K0/C8=";
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
    install -Dm444 dm-sflc.ko $out/lib/modules/${kernel.modDirVersion}/drivers/md/dm-sflc.ko
    install -Dm555 shufflecake $bin/shufflecake
  '';

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
