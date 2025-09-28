{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clr,
  gcc,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiprt";
  version = "2.5.a21e075.3";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "HIPRT";
    tag = finalAttrs.version;
    sha256 = "sha256-3yGhwIsFHlFMCEzuYnXuXNzs99m7f2LTkYaTGs0GEcI=";
  };

  postPatch = ''
    g++ contrib/easy-encryption/cl.cpp -o contrib/easy-encryption/bin/linux/ee64 #replacing prebuilt binary
    substituteInPlace contrib/Orochi/contrib/hipew/src/hipew.cpp --replace-fail '"/opt/rocm/hip/lib/' '"${clr}/lib'
    substituteInPlace hiprt/hiprt_libpath.h --replace-fail '"/opt/rocm/hip/lib/' '"${clr}/lib/'
  '';

  nativeBuildInputs = [
    gcc # required for replacing easy-encryption binary
    cmake
    python3
  ];

  buildInputs = [
    clr
  ];

  cmakeFlags = [
    "-D CMAKE_BUILD_TYPE=Release"
    "-D BAKE_KERNEL=OFF"
    "-D BAKE_COMPILED_KERNEL=OFF"
    "-D BITCODE=ON"
    "-D PRECOMPILE=ON"
    "-D NO_UNITTEST=ON"
    "-D FORCE_DISABLE_CUDA=ON"
  ];

  postInstall = ''
    mv $out/bin $out/lib
    ln -sr $out/lib/libhiprt*64.so $out/lib/libhiprt64.so
    install -v -Dm644 ../scripts/bitcodes/hiprt*_amd_lib_linux.bc $out/lib/
  '';

  meta = {
    homepage = "https://gpuopen.com/hiprt";
    description = "Ray tracing library for HIP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mksafavi
    ];
    platforms = lib.platforms.linux;
  };
})
