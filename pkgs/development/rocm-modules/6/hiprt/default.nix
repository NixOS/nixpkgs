{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clr,
  gcc,
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
  '';

  nativeBuildInputs = [
    gcc # required for replacing easy-encryption binary
    cmake
    clr
  ];
  buildInputs = [
    # TODO: do we need anything here?
  ];

  cmakeFlags = [
    #TODO: mostly copied from the Arch package, verify these:
    "-D CMAKE_BUILD_TYPE=Release"
    "-D HIP_PATH=${clr}"
    "-D BAKE_KERNEL=OFF"
    "-D BAKE_COMPILED_KERNEL=OFF"
    "-D BITCODE=ON"
    "-D PRECOMPILE=ON"
    "-D NO_UNITTEST=ON"
    "-D FORCE_DISABLE_CUDA=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-D CMAKE_INSTALL_BINDIR=bin"
    "-D CMAKE_INSTALL_LIBDIR=lib"
    "-D CMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = {
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT";
    description = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mksafavi
    ];
    platforms = lib.platforms.linux;
  };
})
