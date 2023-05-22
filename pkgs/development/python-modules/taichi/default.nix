{ lib
, fetchFromGitHub
, llvmPackages_14
, cmake
, ninja
, numpy
, pybind11
, scikit-build
, setuptools
, wheel
, git
, libX11
, libXrandr
, libXinerama
, libXcursor
, libXi
, libGL
}:

let
  llvmPackages = llvmPackages_14;
  stdenv = llvmPackages.stdenv;
  libllvm = llvmPackages.libllvm;
in
stdenv.mkDerivation rec {
  pname = "taichi";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "taichi-dev";
    repo = "taichi";
    rev = "v${version}";
    hash = "sha256-xZGAOUaCG7kVDUM0Askqb5FQc286EFP3pmP4IKSnduc=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  stricDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    numpy
    pybind11
    scikit-build
    setuptools
    wheel
    git
  ];

  buildInputs = [
    libllvm
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libGL
  ];

  # See https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace \
      external/SPIRV-Headers/SPIRV-Headers.pc.in \
      external/SPIRV-Cross/pkg-config/spirv-cross-c-shared.pc.in \
      external/SPIRV-Tools/cmake/SPIRV-Tools.pc.in \
      external/SPIRV-Tools/cmake/SPIRV-Tools-shared.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@  \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  propagatedBuildInputs = [];

  meta = with lib; {
    description = "Productive & portable high-performance programming in Python";
    homepage = "https://github.com/taichi-dev/taichi";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
