{ stdenv, lib, fetchgit, cmake, llvmPackages, openssl, writeScript, apple_sdk, bash, emacs, pkgconfig }:

stdenv.mkDerivation rec {
  name = "rtags-${version}";
  version = "2.12";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ llvmPackages.llvm openssl emacs ]
    ++ lib.optionals stdenv.cc.isGNU [ llvmPackages.clang-unwrapped ]
    ++ lib.optionals stdenv.isDarwin [ apple_sdk.libs.xpc apple_sdk.frameworks.CoreServices ];


  src = fetchgit {
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "0bgjcvyvkpqcgw4571iz39sqydmcaz6ymx7kxcmq6j7rffs6qs7l";
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

  enableParallelBuilding = true;

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = https://github.com/andersbakken/rtags;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.allBut [ "i686-linux" ];
  };
}
