{ lib, stdenv, fetchFromGitHub, cmake, cudatoolkit, ncurses, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "nvtop";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = version;
    sha256 = "1h24ppdz7l6l0znwbgir49f7r1fshzjavc6i5j33c6bvr318dpqb";
  };

  cmakeFlags = [
    "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
    "-DNVML_LIBRARIES=${cudatoolkit}/targets/x86_64-linux/lib/stubs/libnvidia-ml.so"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [ cmake addOpenGLRunpath ];
  buildInputs = [ ncurses cudatoolkit ];

  postFixup = ''
    addOpenGLRunpath $out/bin/nvtop
  '';

  meta = with lib; {
    description = "A (h)top like task monitor for NVIDIA GPUs";
    homepage = "https://github.com/Syllo/nvtop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz ];
  };
}
