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
    sha256 = "10j1s7kvnd5823p1kgx3hyca9jz9j27y6xk0q208p095wf8hk105";
  };

  meta = {
    description = "C/C++ client-server indexer based on clang";

    homepage = https://github.com/andersbakken/rtags;

    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.allBut [ "i686-linux" ];
  };
}
