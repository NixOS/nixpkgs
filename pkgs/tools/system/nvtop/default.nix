{ stdenv, fetchFromGitHub, cmake, nvidia_x11, cudatoolkit, ncurses }:

stdenv.mkDerivation rec {
  name = "nvtop-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo  = "nvtop";
    rev = version;
    sha256 = "0gampikzmd1l0vdhvarl0hckl6kmjh2rwcllpg6rrm2p75njw7hv";
  };

  cmakeFlags = [
    "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
    "-DNVML_LIBRARIES=${nvidia_x11}/lib/libnvidia-ml.so.390.67"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses nvidia_x11 cudatoolkit ];

  meta = with stdenv.lib; {
    description = "A (h)top like like task monitor for NVIDIA GPUs";
    homepage = https://github.com/Syllo/nvtop;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz ];
  };
}
