{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "virtio_vmmci";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "voutilad";
    repo = "virtio_vmmci";
    rev = version;
    hash = "sha256-h8yu4+vTgpAD+sKa1KnVD+qubiIlkYtG2nmQnXOi/sk=";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  extraConfig = ''
    CONFIG_RTC_HCTOSYS yes
  '';

  makeFlags = kernel.makeFlags ++ [
    "DEPMOD=echo"
    "INSTALL_MOD_PATH=$(out)"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "OpenBSD VMM Control Interface (vmmci) for Linux";
    homepage = "https://github.com/voutilad/virtio_vmmci";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.linux;
  };

  enableParallelBuilding = true;
}
