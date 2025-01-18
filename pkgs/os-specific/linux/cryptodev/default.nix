{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptodev-linux";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = "cryptodev-linux-${finalAttrs.version}";
    hash = "sha256-N7fGOMEWrb/gm1MDiJgq2QyTOni6n9w2H52baXmRA1g=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = "http://cryptodev-linux.org/";
    maintainers = with maintainers; [ moni ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})
