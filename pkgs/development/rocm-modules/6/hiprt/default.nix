{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clr,
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
    rm -rf contrib/easy-encrypt # contains prebuilt easy-encrypt binaries, we disable encryption
    substituteInPlace contrib/Orochi/contrib/hipew/src/hipew.cpp --replace-fail '"/opt/rocm/hip/lib/' '"${clr}/lib'
    substituteInPlace hiprt/hiprt_libpath.h --replace-fail '"/opt/rocm/hip/lib/' '"${clr}/lib/'
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    clr
  ];

  cmakeFlags = [
    (lib.cmakeBool "BAKE_KERNEL" false)
    (lib.cmakeBool "BAKE_COMPILED_KERNEL" false)
    (lib.cmakeBool "BITCODE" true)
    (lib.cmakeBool "PRECOMPILE" true)
    # needs accelerator
    (lib.cmakeBool "NO_UNITTEST" true)
    # we have no need to support baking encrypted kernels into object files
    (lib.cmakeBool "NO_ENCRYPT" true)
    (lib.cmakeBool "FORCE_DISABLE_CUDA" true)
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
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
