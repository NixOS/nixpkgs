{
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:
kernel.stdenv.mkDerivation {
  pname = "rust-out-of-tree-module";
  version = "0-unstable-2026-10-27";

  src = fetchFromGitHub {
    owner = "Rust-for-linux";
    repo = "rust-out-of-tree-module";

    rev = "a5ea28fa643afbd3b8b5a26e65fe676d7aa0efe3";
    hash = "sha256-FAG4qtz1t0YOZWqjt0CFrkCohDFaLh/sk60r3owjqa4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    broken = kernel.kernelOlder "6.17" || !kernel.withRust;
    description = "Basic template for an out-of-tree Linux kernel module written in Rust";
    homepage = "https://github.com/Rust-for-Linux/rust-out-of-tree-module";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.blitz ];
    platforms = [ "x86_64-linux" ] ++ lib.optional (kernel.kernelAtLeast "6.9") "aarch64-linux";
  };

}
