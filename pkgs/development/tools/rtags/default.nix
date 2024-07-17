{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  llvmPackages,
  openssl,
  apple_sdk,
  emacs,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "rtags";
  version = "2.38";
  nativeBuildInputs = [
    cmake
    pkg-config
    llvmPackages.llvm.dev
  ];
  buildInputs =
    [
      llvmPackages.llvm
      llvmPackages.libclang
      openssl
      emacs
    ]
    ++ lib.optionals stdenv.cc.isGNU [ llvmPackages.clang-unwrapped ]
    ++ lib.optionals stdenv.isDarwin [
      apple_sdk.libs.xpc
      apple_sdk.frameworks.CoreServices
    ];

  src = fetchFromGitHub {
    owner = "andersbakken";
    repo = "rtags";
    rev = "v${version}";
    hash = "sha256-EJ5pC53S36Uu7lM6KuLvLN6MAyrQW/Yk5kPqZNS5m8c=";
    fetchSubmodules = true;
    # unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation
    postFetch = ''
      rm $out/src/rct/tests/testfile_*.txt
    '';
  };

  # This should be fixed with the next verison bump
  # https://github.com/Andersbakken/rtags/issues/1411
  patches = [
    (fetchpatch {
      name = "define-obsolete-function-alias.patch";
      url = "https://github.com/Andersbakken/rtags/commit/63f18acb21e664fd92fbc19465f0b5df085b5e93.patch";
      sha256 = "sha256-dmEPtnk8Pylmf5479ovHKItRZ+tJuOWuYOQbWB/si/Y=";
    })
  ];

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) -fexceptions" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = "https://github.com/andersbakken/rtags";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
}
