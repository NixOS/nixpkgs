{
  lib,
  stdenv,
  kernel,
  mdio-tools,
}:

stdenv.mkDerivation {
  pname = "mdio-netlink";
  version = "${mdio-tools.version}-${kernel.version}";

  inherit (mdio-tools) src;
  sourceRoot = "source/kernel";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.commonMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = {
    description = "Netlink support for MDIO devices";
    homepage = "https://github.com/wkz/mdio-tools";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.jmbaur ];
    platforms = lib.platforms.linux;
  };
}
