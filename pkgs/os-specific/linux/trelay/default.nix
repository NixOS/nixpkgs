{ stdenv, lib, fetchFromGitHub, kernel, kmod }:
let
  version = "22.03.5";
in
stdenv.mkDerivation {
  name = "trelay";
  version = "${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "openwrt";
    rev = "v${version}";
    hash = "sha256-Q0EdFPlOQl4XUtifAupNPor/QRthtijo7Xgo7rikW84=";
  };

  sourceRoot = "source/package/kernel/trelay/src";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postPatch = ''
    cp '${./Makefile}' Makefile
  '';

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "A kernel module that relays ethernet packets between two devices";
    longDescription = ''
      A kernel module that relays ethernet packets between two devices (similar to a bridge),
      but without any MAC address checks.

      This makes it possible to bridge client mode or ad-hoc mode wifi devices to ethernet VLANs,
      assuming the remote end uses the same source MAC address as the device that packets are
      supposed to exit from.
    '';
    homepage = "https://github.com/openwrt/openwrt/tree/main/package/kernel/trelay";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aprl ];
    platforms = platforms.linux;
  };
}
