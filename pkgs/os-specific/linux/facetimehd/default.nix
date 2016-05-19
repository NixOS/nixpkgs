{ stdenv, fetchFromGitHub, kernel }:

# facetimehd is not supported for kernels older than 3.19";
assert stdenv.lib.versionAtLeast kernel.version "3.19";

stdenv.mkDerivation rec {

  name = "facetimehd-${version}-${kernel.version}";
  version = "git-20160503";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = "bcwc_pcie";
    rev = "5a7083bd98b38ef3bd223f7ee531d58f4fb0fe7c";
    sha256 = "0d455kajvn5xav9iilqy7s1qvsy4yb8vzjjxx7bvcgp7aj9ljvdp";
  };

  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/patjak/bcwc_pcie;
    description = "Linux driver for the Facetime HD (Broadcom 1570) PCIe webcam";
    license = licenses.gpl2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
