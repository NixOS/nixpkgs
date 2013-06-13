{ stdenv, fetchurl, kernelDev, zlib }:

let
  ver = "1.3";
  bname = "psmouse-alps-${ver}";
in
stdenv.mkDerivation {
  name = "psmouse-alps-${kernelDev.version}-${ver}";

  src = fetchurl {
    url = http://www.dahetral.com/public-download/alps-psmouse-dlkm-for-3-2-and-3-5/at_download/file;
    name = "${bname}-alt.tar.bz2";
    sha256 = "1ghr8xcyidz31isxbwrbcr9rvxi4ad2idwmb3byar9n2ig116cxp";
  };

  buildPhase = ''
    cd src/${bname}/src
    make -C ${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build \
      SUBDIRS=`pwd` INSTALL_PATH=$out
  '';

  installPhase = ''
    make -C ${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build \
      INSTALL_MOD_PATH=$out SUBDIRS=`pwd` modules_install
  '';
      
  meta = {
    description = "ALPS dlkm driver with all known touchpads";
    homepage = http://www.dahetral.com/public-download/alps-psmouse-dlkm-for-3-2-and-3-5/view;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
