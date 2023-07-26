{ stdenv, lib, fetchFromGitHub, kernel, kmod, lvm2, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "shufflecake";
  version = "0.4.0";
  src = builtins.fetchGit {
    url = "https://codeberg.org/shufflecake/shufflecake-c.git";
    ref = "refs/tags/v${version}";
  };

  hardeningDisable = [ "pic" "format" ];
  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    make -C dm-sflc install \
      KERNELRELEASE=${kernel.modDirVersion} \
      KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      INSTALL_MOD_PATH=$out
    mkdir $out/bin
    cp ./shufflecake $out/bin
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ lvm2 libgcrypt ];

  meta = with lib; {
    description = "Shufflecake is a plausible deniability (hidden storage) layer for Linux.";
    homepage = "https://codeberg.org/shufflecake/shufflecake-c.git";
    license = licenses.gpl2;
    maintainers = [ maintainers."8aed" ];
    platforms = platforms.linux;
  };
}
