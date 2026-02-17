{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
}:

let
  cfg = import ./version.nix;
in

stdenv.mkDerivation rec {
  pname = "batman-adv";
  version = "${cfg.version}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${pname}-${cfg.version}/${pname}-${cfg.version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "pic" ];

  preBuild = ''
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  passthru.tests = {
    systemd-networkd-batadv = nixosTests.systemd-networkd-batadv;
  };

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      fpletz
      philiptaron
    ];
    platforms = with lib.platforms; linux;
  };
}
