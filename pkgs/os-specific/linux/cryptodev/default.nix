{ fetchFromGitHub, lib, stdenv, kernel ? false }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  pname = "cryptodev-linux-1.13";
=======
  pname = "cryptodev-linux-1.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  name = "${pname}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = pname;
<<<<<<< HEAD
    hash = "sha256-EzTPoKYa+XWOAa/Dk7ru02JmlymHeXVX7RMmEoJ1OT0=";
=======
    sha256 = "sha256-vJQ10rG5FGbeEOqCUmH/pZ0P77kAW/MtUarywbtIyHw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
