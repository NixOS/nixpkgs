{
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:
kernel.stdenv.mkDerivation {
  pname = "rust-out-of-tree-module";
  version = "0-unstable-2025-03-10";

  src = fetchFromGitHub {
    owner = "Rust-for-linux";
    repo = "rust-out-of-tree-module";

    rev = "df508ea156314fe281cdaded07bcf89d22c3373a";
    hash = "sha256-pPK+bvtYOKQDllsK2IzhgaNZzdawbIoK20rLU/olHow=";
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
