{ stdenv, lib, fetchgit, cmake, llvmPackages, openssl, writeScript, apple_sdk, bash, emacs }:

stdenv.mkDerivation rec {
  name = "rtags-${version}";
  version = "2.10";

  buildInputs = [ cmake llvmPackages.llvm openssl llvmPackages.clang emacs ]
    ++ lib.optionals stdenv.isDarwin [ apple_sdk.libs.xpc apple_sdk.frameworks.CoreServices ];

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) -fexceptions" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';


  src = fetchgit {
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "0rv5hz4cfc1adpxvp4j4227nfc0p0yrjdc6l9i32jj11p69a5401";
    # unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation
    postFetch = ''
      rm $out/src/rct/tests/testfile_*.txt
    '';
  };

  enableParallelBuilding = true;

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = https://github.com/andersbakken/rtags;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.allBut [ "i686-linux" ];
  };
}
