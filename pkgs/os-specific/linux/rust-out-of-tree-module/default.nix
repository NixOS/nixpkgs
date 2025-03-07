{ lib, fetchFromGitHub, kernel }:
kernel.stdenv.mkDerivation {
  name = "rust-out-of-tree-module";

  src = fetchFromGitHub {
    owner = "Rust-for-linux";
    repo = "rust-out-of-tree-module";

    rev = "7addf9dafba795524f6179a557f7272ecbe1b165";
    hash = "sha256-Bj7WonZ499W/FajbxjM7yBkU9iTxTW7CrRbCSzWbsSc=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

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
