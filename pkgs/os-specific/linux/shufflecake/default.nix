{
  lib,
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  fetchFromGitea,
  libgcrypt,
  lvm2,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "shufflecake";
  version = "0.5.2";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "shufflecake";
    repo = "shufflecake-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EF9VKaqcNJt3hd/CUT+QeW17tc5ByStDanGGwi4uL4s=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [
    libgcrypt
    lvm2
  ];
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  # GCC 14 makes this an error by default, remove when fixed upstream
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  outputs = [
    "out"
    "bin"
  ];

  installPhase = ''
    install -Dm444 dm-sflc.ko $out/lib/modules/${kernel.modDirVersion}/drivers/md/dm-sflc.ko
    install -Dm555 shufflecake $bin/shufflecake
  '';

  meta = with lib; {
    description = "Plausible deniability (hidden storage) layer for Linux";
    homepage = "https://shufflecake.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ oluceps ];
    outputsToInstall = [ "bin" ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "6.1" || kernel.meta.name == "linux-lqx-6.12.1";
  };
})
