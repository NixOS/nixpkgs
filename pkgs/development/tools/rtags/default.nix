{ stdenv, lib, fetchgit, cmake, llvmPackages, openssl, writeScript, apple_sdk, bash, emacs }:

stdenv.mkDerivation rec {
  name = "rtags-${version}";
  version = "2.8-p1";

  buildInputs = [ cmake llvmPackages.llvm openssl llvmPackages.clang emacs ]
    ++ lib.optionals stdenv.isDarwin [ apple_sdk.libs.xpc apple_sdk.frameworks.CoreServices ];

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) -fexceptions" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  src = fetchgit {
    # rev = "refs/tags/v${version}"; # TODO Renable if sha1 below is tagged as release
    rev = "f85bd60f00d51748ea159b00fda7b5bfa78ef571";
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "0g9sgc763c5d695hjffhis19sbaqk8z4884szljf7kbrjxl17y78";
  };

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/{rc,rdm,rp}; do
      install_name_tool -change @rpath/libclang.dylib ${llvmPackages.clang.cc}/lib/libclang.dylib ''${f}
    done
  '';

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = https://github.com/andersbakken/rtags;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.allBut [ "i686-linux" ];
  };
}
