{ lib, stdenv, fetchFromGitHub, bzip2, zlib, autoconf, automake, cmake, help2man, texinfo, libtool, cppzmq
<<<<<<< HEAD
, libarchive, avro-cpp_llvm, boost, zeromq, openssl, pam, libiodbc, libkrb5, gcc, libcxx, which, catch2
, nanodbc_llvm, fmt, nlohmann_json, spdlog, curl }:
=======
, libarchive, avro-cpp_llvm, boost, jansson, zeromq, openssl, pam, libiodbc, libkrb5, gcc, libcxx, which, catch2
, nanodbc_llvm, fmt, nlohmann_json, spdlog }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  avro-cpp = avro-cpp_llvm;
  nanodbc = nanodbc_llvm;
in
let
  common = import ./common.nix {
    inherit lib stdenv bzip2 zlib autoconf automake cmake
<<<<<<< HEAD
      help2man texinfo libtool cppzmq libarchive
      zeromq openssl pam libiodbc libkrb5 gcc libcxx
      boost avro-cpp which catch2 nanodbc fmt nlohmann_json
      spdlog curl;
=======
      help2man texinfo libtool cppzmq libarchive jansson
      zeromq openssl pam libiodbc libkrb5 gcc libcxx
      boost avro-cpp which catch2 nanodbc fmt nlohmann_json
      spdlog;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
rec {

  # irods: libs and server package
<<<<<<< HEAD
  irods = stdenv.mkDerivation (finalAttrs: common // {
    version = "4.3.0";
=======
  irods = stdenv.mkDerivation (common // rec {
    version = "4.2.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pname = "irods";

    src = fetchFromGitHub {
      owner = "irods";
      repo = "irods";
<<<<<<< HEAD
      rev = finalAttrs.version;
      sha256 = "sha256-rceDGFpfoFIByzDOtgNIo9JRoVd0syM21MjEKoZUQaE=";
      fetchSubmodules = true;
    };

=======
      rev = version;
      sha256 = "0prcsiddk8n3h515jjapgfz1d6hjqywhrkcf6giqd7xc7b0slz44";
      fetchSubmodules = true;
    };

    # Patches:
    # irods_root_path.patch : the root path is obtained by stripping 3 items of the path,
    #                         but we don't use /usr with nix, so remove only 2 items.
    patches = [ ./irods_root_path.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # fix build with recent llvm versions
    env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-register -Wno-deprecated-declarations";

    postPatch = common.postPatch + ''
      patchShebangs ./test
      substituteInPlace plugins/database/CMakeLists.txt --replace "COMMAND cpp" "COMMAND ${gcc.cc}/bin/cpp"
<<<<<<< HEAD
=======
      substituteInPlace cmake/server.cmake --replace "DESTINATION usr/sbin" "DESTINATION sbin"
      substituteInPlace cmake/server.cmake --replace "IRODS_DOC_DIR usr/share" "IRODS_DOC_DIR share"
      substituteInPlace cmake/runtime_library.cmake --replace "DESTINATION usr/lib" "DESTINATION lib"
      substituteInPlace cmake/development_library.cmake --replace "DESTINATION usr/lib" "DESTINATION lib"
      substituteInPlace cmake/development_library.cmake --replace "DESTINATION usr/include" "DESTINATION include"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      for file in unit_tests/cmake/test_config/*.cmake
      do
        substituteInPlace $file --replace "CATCH2}/include" "CATCH2}/include/catch2"
      done
      export cmakeFlags="$cmakeFlags
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,$out/lib
        "

<<<<<<< HEAD
      substituteInPlace server/auth/CMakeLists.txt --replace SETUID ""
=======
      substituteInPlace cmake/server.cmake --replace SETUID ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';

    meta = common.meta // {
      longDescription = common.meta.longDescription + "This package provides the servers and libraries.";
    };
  });


  # icommands (CLI) package, depends on the irods package
<<<<<<< HEAD
  irods-icommands = stdenv.mkDerivation (finalAttrs: common // {
    version = "4.3.0";
=======
  irods-icommands = stdenv.mkDerivation (common // rec {
    version = "4.2.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pname = "irods-icommands";

    src = fetchFromGitHub {
      owner = "irods";
      repo = "irods_client_icommands";
<<<<<<< HEAD
      rev = finalAttrs.version;
      sha256 = "sha256-90q1GPkoEUoiQXM6cA+DWwth7g8v93V471r9jm+l9aw=";
    };

=======
      rev = version;
      sha256 = "0wgs585j2lp820py2pbizsk54xgz5id96fhxwwk9lqhbzxhfjhcg";
    };

    patches = [ ./zmqcpp-deprecated-send_recv.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
