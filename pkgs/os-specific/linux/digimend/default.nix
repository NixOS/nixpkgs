{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "digimend";
  version = "13-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "digimend";
    repo = "digimend-kernel-drivers";
    rev = "f3c7c7f1179fc786a8e5aad027d4db904c31b42c";
    hash = "sha256-5kJj3SJfzrQ3n9r1YOn5xt0KO9WcEf0YpNMjiZEYMEo=";
  };

  postPatch = ''
    sed 's/udevadm /true /' -i Makefile
    sed 's/depmod /true /' -i Makefile
  '';

  # Fix build on Linux kernel >= 5.18
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=implicit-fallthrough" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=${placeholder "out"}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "DIGImend graphics tablet drivers for the Linux kernel";
    homepage = "https://digimend.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ PuercoPop ];
    platforms = platforms.linux;
  };
}
