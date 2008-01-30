args: with args;
stdenv.mkDerivation {
  name = "acerhk_kernel_patch-0.5.35";
  kernel = kernel.src;
  inherit debug;
  acerhk = fetchurl {
    url = http://mirror.switch.ch/mirror/gentoo/distfiles/acerhk-0.5.35.tar.bz2;
    sha256 = "1kg002qraa8vha2cgza3z74d9j46g180g5b44zbv64dsa9n2j4b0";
  };

  buildInputs = [gnupatch];
  
  builder = ./builder.sh;

  meta = { 
      description = "Hotkey driver for some Acer";
      homepage =  http://www.cakey.de/acerhk/;
      license = "GPL-2";
  };
}
