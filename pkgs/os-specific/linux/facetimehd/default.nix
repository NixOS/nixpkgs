{ stdenv, fetchFromGitHub, kernel }:

# facetimehd is not supported for kernels older than 3.19";
assert stdenv.lib.versionAtLeast kernel.version "3.19";

stdenv.mkDerivation rec {

  name = "facetimehd-${version}-${kernel.version}";
  version = "git-20160127";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = "bcwc_pcie";
    rev = "186e9f9101ed9bbd7cc8d470f840d4a74c585ca7";
    sha256 = "1frsf6z6v94cz9fww9rbnk926jzl36fp3w2d1aw6djhzwm80a5gs";
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
