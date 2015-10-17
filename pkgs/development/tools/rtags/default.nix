{ stdenv, fetchgit, cmake, llvm, openssl, clang, writeScript, bash }:

let llvm-config-wrapper = writeScript "llvm-config" ''
      #! ${bash}/bin/bash
      if [[ "$1" = "--cxxflags" ]]; then
        echo $(${llvm}/bin/llvm-config "$@") -isystem ${clang.cc}/include
      else
        ${llvm}/bin/llvm-config "$@"
      fi
    '';

in stdenv.mkDerivation rec {
  name = "rtags-${version}";
  rev = "9fed420d20935faf55770765591fc2de02eeee28";
  version = "${stdenv.lib.strings.substring 0 7 rev}";

  buildInputs = [ cmake llvm openssl clang ];

  preConfigure = ''
    export LIBCLANG_LLVM_CONFIG_EXECUTABLE=${llvm-config-wrapper}
  '';

  src = fetchgit {
    inherit rev;
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "1sb6wfknhvrgirqp65paz7kihv4zgg8g5f7a7i14i10sysalxbif";
  };

  meta = {
    description = "C/C++ client-server indexer based on clang";

    homepage = https://github.com/andersbakken/rtags;

    license = stdenv.lib.licenses.gpl3;
  };
}
