{ fetchFromGitHub, stdenv,

# Kernel dependencies
kernel
}:

with stdenv.lib;

assert kernel != null;

stdenv.mkDerivation rec {
  name = "applespi-master-${hash}-${kernel.version}";
  hash = "aeb7ca96eaf7c82418eb967aba5d991a33006899";

  src = fetchFromGitHub {
    owner = "cb22";
    repo = "macbook12-spi-driver";
    rev = "${hash}";
    sha256 = "04hcy8cfm2kdrqs1cyd9s37x4qh5az5vdy477y5lfw2f33rwid1l";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;
 
  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = {
    description = "WIP input driver for the SPI touchpad / keyboard found in the 12\" MacBook (MacBook8,1 + MacBook9,1)";

    homepage = "https://github.com/cb22/macbook12-spi-driver";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
