{ lib, stdenv, fetchFromGitHub, bzip2, zlib, autoconf, automake, cmake, help2man, texinfo, libtool, cppzmq
, libarchive, avro-cpp_llvm, boost, zeromq, openssl, pam, libiodbc, libkrb5, gcc, libcxx, which, catch2
, nanodbc_llvm, fmt, nlohmann_json, spdlog, curl }:

let
  avro-cpp = avro-cpp_llvm;
  nanodbc = nanodbc_llvm;
in
let
  common = import ./common.nix {
    inherit lib stdenv bzip2 zlib autoconf automake cmake
      help2man texinfo libtool cppzmq libarchive
      zeromq openssl pam libiodbc libkrb5 gcc libcxx
      boost avro-cpp which catch2 nanodbc fmt nlohmann_json
      spdlog curl;
  };
in
rec {

  # irods: libs and server package
  irods = stdenv.mkDerivation (finalAttrs: common // {
    version = "4.3.0";
    pname = "irods";

    src = fetchFromGitHub {
      owner = "irods";
      repo = "irods";
      rev = finalAttrs.version;
      sha256 = "sha256-rceDGFpfoFIByzDOtgNIo9JRoVd0syM21MjEKoZUQaE=";
      fetchSubmodules = true;
    };

    # fix build with recent llvm versions
    env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-register -Wno-deprecated-declarations";

    postPatch = common.postPatch + ''
      patchShebangs ./test
      substituteInPlace plugins/database/CMakeLists.txt --replace "COMMAND cpp" "COMMAND ${gcc.cc}/bin/cpp"
      for file in unit_tests/cmake/test_config/*.cmake
      do
        substituteInPlace $file --replace "CATCH2}/include" "CATCH2}/include/catch2"
      done
      export cmakeFlags="$cmakeFlags
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,$out/lib
        "

      substituteInPlace server/auth/CMakeLists.txt --replace SETUID ""
    '';

    meta = common.meta // {
      longDescription = common.meta.longDescription + "This package provides the servers and libraries.";
    };
  });


  # icommands (CLI) package, depends on the irods package
  irods-icommands = stdenv.mkDerivation (finalAttrs: common // {
    version = "4.3.0";
    pname = "irods-icommands";

    src = fetchFromGitHub {
      owner = "irods";
      repo = "irods_client_icommands";
      rev = finalAttrs.version;
      sha256 = "sha256-90q1GPkoEUoiQXM6cA+DWwth7g8v93V471r9jm+l9aw=";
    };

    buildInputs = common.buildInputs ++ [ irods ];

    postPatch = common.postPatch + ''
      patchShebangs ./bin
    '';

    cmakeFlags = common.cmakeFlags ++ [
      "-DCMAKE_INSTALL_PREFIX=${stdenv.out}"
      "-DIRODS_DIR=${irods}/lib/irods/cmake"
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
      "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
      "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
    ];

    meta = common.meta // {
      description = common.meta.description + " CLI clients";
      longDescription = common.meta.longDescription + "This package provides the CLI clients, called 'icommands'.";
    };
  });
}
