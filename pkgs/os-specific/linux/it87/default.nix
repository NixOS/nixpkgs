{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "it87-${version}-${kernel.version}";
  version = "unstable-2025-03-27";

  # Original is no longer maintained.
  # This is the same upstream as the AUR uses.
  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    rev = "4bff981a91bf9209b52e30ee24ca39df163a8bcd";
    hash = "sha256-hjNph67pUaeL4kw3cacSz/sAvWMcoN2R7puiHWmRObM=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  meta = with lib; {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/frankcrawford/it87";
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    teams = [ teams.lumiguide ];
  };
}
