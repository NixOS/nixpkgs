{ lib
, stdenv
, fetchurl
, fetchpatch
, kernel
}:

let cfg = import ./version.nix; in

stdenv.mkDerivation rec {
  pname = "batman-adv";
  version = "${cfg.version}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${pname}-${cfg.version}/${pname}-${cfg.version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  patches = [
    #  batman-adv: make mc_forwarding atomic
    (fetchpatch {
      url = "https://git.open-mesh.org/batman-adv.git/blobdiff_plain/c142c00f6b1a2ad5f5d74202fb1249e6a6575407..56db7c0540e733a1f063ccd6bab1b537a80857eb:/net/batman-adv/multicast.c";
      hash = "sha256-2zXg8mZ3/iK9E/kyn+wHSrlLq87HuK72xuXojQ9KjkI=";
    })
    #  batman-adv: compat: Add atomic mc_fowarding support for stable kernels
    (fetchpatch {
      url = "https://git.open-mesh.org/batman-adv.git/blobdiff_plain/f07a0c37ab278fb6a9e95cad89429b1282f1ab59..350adcaec82fbaa358a2406343b6130ac8dad126:/net/batman-adv/multicast.c";
      hash = "sha256-r/Xp5bmDo9GVfAF6bn2Xq+cOq5ddQe+D5s/h37uI6bM=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [
    "KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "pic" ];

  preBuild = ''
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
