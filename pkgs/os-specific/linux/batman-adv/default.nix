{ stdenv, fetchurl, kernel }:

let cfg = import ./version.nix; in

stdenv.mkDerivation rec {
  pname = "batman-adv";
  version = "${cfg.version}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${pname}-${cfg.version}/${pname}-${cfg.version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  preBuild = ''
    makeFlags="KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = https://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
