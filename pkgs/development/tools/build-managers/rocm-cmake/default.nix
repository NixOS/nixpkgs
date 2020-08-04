{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rocm-cmake";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${version}";
    sha256 = "1x1mj1acarhin319zycms8sqm9ylw2mcdbkpqjlb8yfsgiaa99ja";
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
