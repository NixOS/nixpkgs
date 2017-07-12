{ stdenv, fetchurl, kernel }:

let base = "batman-adv-2017.1"; in

stdenv.mkDerivation rec {
  name = "${base}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${base}/${base}.tar.gz";
    sha256 = "05cck0mlg8xsvbra69x6i25xclsq1xc49dggxq81gi086c14h67c";
  };

  patches = [
    (fetchurl {
      url = "https://git.open-mesh.org/batman-adv.git/patch/33e9de0c769c7b0c5e615a5788b0f09655304720";
      sha256 = "1yc2iac6dg32hxqfwip7jw5bnhi6ikmxsaw6z2v6vll37fqha6gy";
    })
  ];

  hardeningDisable = [ "pic" ];

  preBuild = ''
    makeFlags="KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
