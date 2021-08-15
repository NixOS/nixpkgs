{ lib, stdenv, fetchFromGitHub, cmake, cudatoolkit, ncurses, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "nvtop";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = version;
    sha256 = "sha256-B/SRTOMp3VYShjSGxnF1ll58ijddJG7w/7nPK1fMltk=";
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
