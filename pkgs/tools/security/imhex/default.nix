{ lib
, stdenv
, cmake
, fetchFromGitHub
, mbedtls
, gtk3
, pkg-config
, capstone
, libGLU
, glfw3
, file
, python3
, curl
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  pname = "ImHex";
  version = "1.11.1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3S6mQ/fmxT2m1oH/MRn+3egj+HPYzaZys82nZ3RcE1I=";
  };

  patterns_src = fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    rev = "47fc94928960397feba24dd687f9b1c803213b34";
    sha256 = "sha256-bufoyXbqRS/hIOU03ACBfHdrATTnuW5R1IiNLF/B9t4=";
  };

  nativeBuildInputs = [ cmake python3 pkg-config xlibsWrapper ];

  buildInputs = [
    mbedtls
    gtk3
    capstone
    libGLU
    glfw3
    file
    curl
  ];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  installPhase = ''
    install -D imhex $out/bin/imhex
    install -D plugins/builtin/builtin.hexplug $out/bin/plugins/builtin.hexplug
    install -D plugins/libimhex/libimhex.so $out/lib/libimhex.so

    cp -R ${patterns_src}/* $out/bin
  '';

  fixupPhase = ''
    fixRpath() {
      rpath=$(patchelf --print-rpath "$1" | sed 's/\/build\/source\/plugins\/libimhex:://g')
      patchelf --set-rpath "$2:$rpath" "$1"
    }
    fixRpath $out/bin/plugins/builtin.hexplug  $out/lib
    fixRpath $out/bin/imhex $out/lib
  '';

  hardeningDisable = [ "format" ];
  doCheck = false;

  meta = with lib; {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    license = with licenses; [ gpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ luis ];
  };
}
