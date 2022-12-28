{ fetchFromGitHub, lib, stdenv, kernel ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.12";
  name = "${pname}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = pname;
    sha256 = "sha256-vJQ10rG5FGbeEOqCUmH/pZ0P77kAW/MtUarywbtIyHw=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";
  prefix = "\${out}";

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = "http://cryptodev-linux.org/";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
