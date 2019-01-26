{ stdenv, kernel, wireguard-tools, perl }:

# module requires Linux >= 3.10 https://www.wireguard.io/install/#kernel-requirements
assert stdenv.lib.versionAtLeast kernel.version "3.10";

stdenv.mkDerivation rec {
  name = "wireguard-${version}";
  inherit (wireguard-tools) src version;

  preConfigure = ''
    cd src
    sed -i '/depmod/,+1d' Makefile
  '';

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";

  NIX_CFLAGS = ["-Wno-error=cpp"];

  nativeBuildInputs = [ perl ] ++ kernel.moduleBuildDependencies;

  buildPhase = "make module";

  meta = with stdenv.lib; {
    inherit (wireguard-tools.meta) homepage license maintainers;
    description = "Kernel module for the WireGuard secure network tunnel";
    platforms = platforms.linux;
  };
}
