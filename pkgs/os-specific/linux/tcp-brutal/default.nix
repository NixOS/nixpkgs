{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "tcp-brutal-${finalAttrs.version}-${kernel.version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "tcp-brutal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rx8JgQtelssslJhFAEKq73LsiHGPoML9Gxvw0lsLacI=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_RELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install brutal.ko -Dm444 -t ${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/net/brutal
  '';

  meta = {
    description = "Hysteria's congestion control algorithm ported to TCP, as a Linux kernel module";
    homepage = "https://github.com/apernet/tcp-brutal";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wakimizu ];
    broken = kernel.kernelOlder "4.9";
  };
})
