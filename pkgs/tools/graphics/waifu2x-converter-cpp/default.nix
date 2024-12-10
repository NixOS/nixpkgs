{
  cmake,
  fetchFromGitHub,
  makeWrapper,
  opencv4,
  lib,
  stdenv,
  ocl-icd,
  opencl-headers,
  OpenCL,
  config,
  cudaSupport ? config.cudaSupport,
  cudatoolkit ? null,
}:

stdenv.mkDerivation rec {
  pname = "waifu2x-converter-cpp";
  version = "5.3.4";

  src = fetchFromGitHub {
    owner = "DeadSix27";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rv8bnyxz89za6gwk9gmdbaf3j7c1j52mip7h81rir288j35m84x";
  };

  patches = [
    # Remove the hard-coded compiler on Darwin and use the one in stdenv.
    ./waifu2x_darwin_build.diff
  ];

  buildInputs =
    [
      opencv4
    ]
    ++ lib.optional cudaSupport cudatoolkit
    ++ lib.optional stdenv.isDarwin OpenCL
    ++ lib.optionals stdenv.isLinux [
      ocl-icd
      opencl-headers
    ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  preFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/waifu2x-converter-cpp --prefix LD_LIBRARY_PATH : "${ocl-icd}/lib"
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = {
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    homepage = "https://github.com/DeadSix27/waifu2x-converter-cpp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xzfc ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "waifu2x-converter-cpp";
  };
}
