{ lib, stdenv, fetchurl, fetchpatch, kernel }:

let cfg = import ./version.nix; in

stdenv.mkDerivation rec {
  pname = "batman-adv";
  version = "${cfg.version}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${pname}-${cfg.version}/${pname}-${cfg.version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  patches = [
    (fetchpatch {
      # Fix build with Kernel>=5.12, remove for batman-adv>=2021.1
      url = "https://git.open-mesh.org/batman-adv.git/patch/6d67ca7f530d4620e3d066b02aefbfd8893d6c05?hp=362da918384286a959ad7c3455d9d33d9ff99d7d";
      sha256 = "039x67yfkwl0b8af8vwx5m58ji2qn8x44rr1rkzi5j43cvmnh2cg";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  preBuild = ''
    makeFlags="KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ fpletz hexa ];
    platforms = with lib.platforms; linux;
  };
}
