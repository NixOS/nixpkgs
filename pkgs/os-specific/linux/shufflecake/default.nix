{ lib, kernel, stdenv, fetchFromGitea, libgcrypt, lvm2 }:
stdenv.mkDerivation (finalAttrs: {
  name = "shufflecake";
  version = "0.4.4";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "shufflecake";
    repo = "shufflecake-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zvGHM5kajJlROI8vg1yZQ5NvJvuGLV2iKvumdW8aglA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ libgcrypt lvm2 ];
  makeFlags = kernel.makeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  outputs = [ "out" "bin" ];

  installPhase = ''
    install -Dm444 dm-sflc.ko $out/lib/modules/${kernel.modDirVersion}/drivers/md/dm-sflc.ko
    install -Dm555 shufflecake $bin/shufflecake
  '';

  meta = with lib; {
    description = "A plausible deniability (hidden storage) layer for Linux";
    homepage = "https://shufflecake.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ oluceps ];
    outputsToInstall = [ "bin" ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "6.1";
  };
})

