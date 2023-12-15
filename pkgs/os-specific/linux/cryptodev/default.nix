{ fetchFromGitHub, lib, stdenv, kernel ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.13";
  name = "${pname}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = pname;
    hash = "sha256-EzTPoKYa+XWOAa/Dk7ru02JmlymHeXVX7RMmEoJ1OT0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
    "prefix=$(out)"
  ];

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = "http://cryptodev-linux.org/";
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
