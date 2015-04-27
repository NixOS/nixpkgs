{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  name = "fusionio-iomemory-vsl-3.2.10";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://drive.google.com/uc?export=download&id=0B7U0_ZBLoB2WbXFMbExEMUFCcWM";
    sha256 = "1zm20aa1jmmqcqkb4p9r4jsgbg371zr1abdz32rw02i9687fsgcc";
  };

  prePatch = ''
    cd root/usr/src/iomemory-vsl-*
  '';

  patches = stdenv.lib.optional (stdenv.lib.versionAtLeast kernel.version "3.19") ./vsl-fix-file-inode.patch;

  preBuild = ''
    sed -i Makefile kfio_config.sh \
      -e "s,\(KERNELDIR=\"\|KERNEL_SRC =\)[^\"]*,\1${kernel.dev}/lib/modules/${kernel.modDirVersion}/build,g"
    export DKMS_KERNEL_VERSION=${kernel.modDirVersion}
    export TARGET="x86_64_cc48"
  '';

  installPhase = ''
    export INSTALL_ROOT=$out
    make modules_install
  '';

  meta = with stdenv.lib; {
    homepage = http://fusionio.com;
    description = "kernel driver for accessing fusion-io cards";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    broken = stdenv.system != "x86_64-linux";
    maintainers = with maintainers; [ wkennington ];
  };
}
