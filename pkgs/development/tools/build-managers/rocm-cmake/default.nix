{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rocm-cmake";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${version}";
    hash = "sha256-1T0S2GWA/ojRZMRyWgtFQ2rzmIqvMvaa19jI4Fl9R44=";
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
