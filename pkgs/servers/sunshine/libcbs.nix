{ stdenv
, fetchFromGitHub
, cmake
, nasm
}:
stdenv.mkDerivation {
  pname = "libcbs";
  version = "unstable-2022-02-07";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "build-deps";
    # repo is not versioned -- used latest commit combined with sunshine release
    rev = "d6e889188ca10118d769ee1ee3cddf9cf485642b";
    fetchSubmodules = true;
    sha256 = "sha256-6xQDJey5JrZXyZxS/yhUBvFi6UD5MsQ3uVtUFrG09Vc=";
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  # modify paths to allow patches to be applied directly by derivation
  prePatch = ''
    substituteInPlace ffmpeg_patches/cbs/* \
      --replace 'a/libavcodec' 'a/ffmpeg_sources/ffmpeg/libavcodec' \
      --replace 'b/libavcodec' 'b/ffmpeg_sources/ffmpeg/libavcodec' \
      --replace 'a/libavutil' 'a/ffmpeg_sources/ffmpeg/libavutil' \
      --replace 'b/libavutil' 'b/ffmpeg_sources/ffmpeg/libavutil'

    substituteInPlace cmake/ffmpeg_cbs.cmake \
      --replace '--enable-static' '--enable-shared --enable-pic' \
      --replace 'add_library(cbs' 'add_library(cbs SHARED' \
      --replace 'libcbs.a' 'libcbs.so'
  '';

  patches = [
    "ffmpeg_patches/cbs/01-explicit-intmath.patch"
    "ffmpeg_patches/cbs/02-include-cbs-config.patch"
    "ffmpeg_patches/cbs/03-remove-register.patch"
    "ffmpeg_patches/cbs/04-size-specifier.patch"
  ];

  CFLAGS = [
    "-Wno-format-security"
  ];
}
