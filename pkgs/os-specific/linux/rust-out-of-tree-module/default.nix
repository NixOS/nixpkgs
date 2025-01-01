{ lib, fetchFromGitHub, kernel, unstableGitUpdater }:
kernel.stdenv.mkDerivation {
  pname = "rust-out-of-tree-module";
  version = "0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "Rust-for-linux";
    repo = "rust-out-of-tree-module";

    rev = "9872947486bb8f60b0d11db15d546a3d06156ec5";
    hash = "sha256-TzCySY7uQac98dU+Nu5dC4Usm7oG0iIdZZmZgAOpni4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    broken = !kernel.withRust;
    description = "Basic template for an out-of-tree Linux kernel module written in Rust";
    homepage = "https://github.com/Rust-for-Linux/rust-out-of-tree-module";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.blitz ];
    platforms = [ "x86_64-linux" ]
      ++ lib.optional (kernel.kernelAtLeast "6.9") "aarch64-linux";
  };

}
