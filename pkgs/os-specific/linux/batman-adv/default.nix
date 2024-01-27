{ lib
, stdenv
, fetchurl
, fetchpatch2
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
    # batman-adv: compat: Fix skb_vlan_eth_hdr conflict in stable kernels
    (fetchpatch2 {
      url = "https://git.open-mesh.org/batman-adv.git/commitdiff_plain/be69e50e8c249ced085d41ddd308016c1c692174?hp=74d3c5e1c682a9efe31b75e8986668081a4b5341";
      sha256 = "sha256-yfEiU74wuMSKal/6mwzgdccqDMEv4P7CkAeiSAEwvjA=";
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
    maintainers = with lib.maintainers; [ fpletz philiptaron ];
    platforms = with lib.platforms; linux;
  };
}
