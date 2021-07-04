{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, boost, pkg-config,
eigen, libpng, python, openexr, openimageio2,
opencolorio_1, xercesc, osl, makeWrapper, lz4
}:

mkDerivation rec {
  pname = "appleseed";
  version = "unstable-2021-03-27";

  src = fetchFromGitHub {
    owner  = "appleseedhq";
    repo   = "appleseed";
    rev    = "1ba62025b5db722e179a2219d8d366c34bfaa342";
    sha256 = "18d78rgcgbb32yprnbfrawyzq2lv0hj0m3fh5ss01gc8km5282bp";
  };

  nativeBuildInputs = [
    cmake pkg-config makeWrapper
  ];
  buildInputs = [
    boost eigen libpng python openexr openimageio2 opencolorio_1
    xercesc osl lz4
  ];

  patches = [
    # Support OSL compiler >= 1.11.8
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/appleseedhq/appleseed/pull/2900.patch";
      sha256 = "sha256-vAEbjBSuCryR7S5QrUzZfzK1K/wDuuc9qq8AVjQg7qU=";
    })
  ];

  postPatch = ''
    # required for openimageio2
    substituteInPlace CMakeLists.txt \
      --replace 'CMAKE_CXX_STANDARD 11' 'CMAKE_CXX_STANDARD 14'
  '';

  cmakeFlags = [
    "-DINSTALL_TESTS=OFF"
    "-DWITH_BENCH=OFF" # installation fails
    "-DUSE_SSE=ON"
    "-DUSE_SSE42=ON"
    "-DUSE_STATIC_BOOST=OFF"
  ];

  meta = with lib; {
    description = "Open source, physically-based global illumination rendering engine";
    homepage = "https://appleseedhq.net/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.mit;
    platforms = platforms.linux;
  };

  # Work around a bug in the CMake build:
  postInstall = ''
    chmod a+x $out/bin/*
    wrapProgram $out/bin/appleseed.studio --set PYTHONHOME ${python}
  '';
}
