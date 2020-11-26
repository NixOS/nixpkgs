{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rocm-cmake";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${version}";
    sha256 = "13j7gmcy1j6qsydgccmgiacg6sj38l5mlwn4ck8qizl0cpc14gfm";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/rocm-cmake";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
