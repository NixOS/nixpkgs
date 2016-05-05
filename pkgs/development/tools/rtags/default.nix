{ stdenv, fetchgit, cmake, llvmPackages, openssl, writeScript, bash, emacs }:

stdenv.mkDerivation rec {
  name = "rtags-${version}";
  version = "git-2016-04-29";
  rev = "233543d343bf86fa31c35ee21242fa2da3a965ab";

  buildInputs = [ cmake llvmPackages.llvm openssl llvmPackages.clang emacs ];

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags)" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  src = fetchgit {
    inherit rev;
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "1jzmpbkx1z8dnpr0ndclb6c3dxnf90ifr8j1nzz4j8cvzdpc3lzc";
  };

  meta = {
    description = "C/C++ client-server indexer based on clang";

    homepage = https://github.com/andersbakken/rtags;

    license = stdenv.lib.licenses.gpl3;
  };
}
