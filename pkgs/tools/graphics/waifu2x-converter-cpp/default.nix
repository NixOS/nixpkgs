{ stdenv
, fetchFromGitHub
, makeWrapper

, cmake
, cudatoolkit
, ocl-icd
, opencl-headers
, opencv3
, pkgconfig
, waifu2x-converter-cpp

, cudaSupport ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "waifu2x-converter-cpp";
  version = "5.3";

  src = fetchFromGitHub {
    owner = "DeadSix27";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i627n34mv73ihd09mlndzdwx8j613l6r8wqs42n42k7yl8naz5i";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ocl-icd opencl-headers opencv3 ]
    ++ optional cudaSupport cudatoolkit;

  patches = [
  # Handle failed attempt to write to the Nix store
  # https://github.com/DeadSix27/waifu2x-converter-cpp/pull/184
    ./erofs.patch
  # Allow version override
    ./no-git-version.patch
  ];

  postPatch = ''
    sed -i 's,"/system/vendor/lib/libOpenCL.so","${ocl-icd}/lib/libOpenCL.so",' src/modelHandler_OpenCL.cpp
  '';

  # The build script tries to determine the project version
  # from the git repo. This doesn't work since Nix discards
  # .git even when it does a clone.
  cmakeFlags = [ "-DGIT_TAG=v${version}" ]
    ++ optional (waifu2x-converter-cpp.doCheck or false) "-DENABLE_TESTS=ON";

  preCheck = ''
    export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
    ln -s ../models_rgb ./
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/DeadSix27/waifu2x-converter-cpp;
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming xzfc ];
  };
}
