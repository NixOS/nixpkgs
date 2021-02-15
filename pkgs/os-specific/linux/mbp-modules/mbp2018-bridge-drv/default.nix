{ lib, stdenv, kernel, fetchFromGitHub, }:

stdenv.mkDerivation rec {
  pname = "mbp2018-bridge-drv";
  version = "0.01";

  src = fetchFromGitHub {
    owner = "MCMrARM";
    repo = "mbp2018-bridge-drv";
    rev = "${version}";
    sha256 = "0ac2l51ybfrvg8m36x67rsvgjqs1vwp7c89ssvbjkrcq3y4qdb53";
  };

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      -j$NIX_BUILD_CORES M=$(pwd) modules
  '';

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build  \
      INSTALL_MOD_PATH=$out M=$(pwd) modules_install
  '';

  meta = with lib; {
    description = "A driver for MacBook models 2018 and newer, which makes the keyboard, mouse and audio output work.";
    longDescription = ''
      A driver for MacBook models 2018 and newer, implementing the VHCI (required for mouse/keyboard/etc.) and audio functionality.
    '';
    homepage = "https://github.com/MCMrARM/mbp2018-bridge-drv";
    license = lib.licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.hlolli ];
  };
}
