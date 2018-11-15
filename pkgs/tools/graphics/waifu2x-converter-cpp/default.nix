{ stdenv, fetchFromGitHub, cmake, pkgconfig, opencv3, opencl-headers,
  cudaSupport ? false , cudatoolkit ? null }:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "waifu2x-converter-cpp";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "DeadSix27";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cfab4239zidql7wgn0gprnz0zp6sy2dknxr5pa8vx7c6g6vgh20";
  };

  preConfigure = ''
    mkdir -p $out
    cp -r models_rgb $out/
    substituteInPlace src/main.cpp --replace "models_rgb" "$out/models_rgb"
  '';

  buildInputs =
    [ opencv3 opencl-headers ] ++ stdenv.lib.optional cudaSupport cudatoolkit;
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/DeadSix27/waifu2x-converter-cpp;
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ mt-caret ];
  };
}
