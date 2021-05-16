{ stdenv, lib, fetchgit, cmake, llvmPackages, openssl, apple_sdk, emacs, pkg-config }:

stdenv.mkDerivation rec {
  pname = "rtags";
  version = "2.38";
  nativeBuildInputs = [ cmake pkg-config llvmPackages.llvm.dev ];
  buildInputs = [ llvmPackages.llvm llvmPackages.libclang openssl emacs ]
    ++ lib.optionals stdenv.cc.isGNU [ llvmPackages.clang-unwrapped ]
    ++ lib.optionals stdenv.isDarwin [ apple_sdk.libs.xpc apple_sdk.frameworks.CoreServices ];

  src = fetchgit {
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "1iwvp7a69sj3wqjgcnyh581qrpicxzi2lfjkxqpabpyjkl5nk7hh";
    # unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation
    postFetch = ''
      rm $out/src/rct/tests/testfile_*.txt
    '';
  };

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
