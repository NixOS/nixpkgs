{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  zlib,
  autoconf,
  automake,
  cmake,
  help2man,
  texinfo,
  libtool,
  cppzmq,
  libarchive,
  avro-cpp_llvm,
  boost,
  zeromq,
  openssl,
  pam,
  libiodbc,
  libkrb5,
  gcc,
  libcxx,
  which,
  catch2,
  nanodbc_llvm,
  fmt,
  nlohmann_json,
  spdlog_llvm,
  curl,
  bison,
  flex,
}:

let
  spdlog_rods = spdlog_llvm.overrideAttrs (attrs: {
    inherit stdenv;
    version = "1.10.0";
    src = attrs.src.override {
      rev = "v1.10.0";
      hash = "sha256-c6s27lQCXKx6S1FhZ/LiKh14GnXMhZtD1doltU4Avws=";
    };
    postPatch = ''
      substituteInPlace cmake/spdlog.pc.in \
        --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
    '';
  });
in
let
  avro-cpp = avro-cpp_llvm;
  nanodbc = nanodbc_llvm;

  common = import ./common.nix {
    inherit
      lib
      stdenv
      bzip2
      zlib
      autoconf
      automake
      cmake
      help2man
      texinfo
      libtool
      cppzmq
      libarchive
      zeromq
      openssl
      pam
      libiodbc
      libkrb5
      gcc
      libcxx
      boost
      avro-cpp
      which
      catch2
      nanodbc
      fmt
      nlohmann_json
      curl
      spdlog_rods
      bison
      flex
      ;
  };
in
rec {

  # irods: libs and server package
  irods = stdenv.mkDerivation (
    finalAttrs:
    common
    // {
      version = "4.3.3";
      pname = "irods";

      src = fetchFromGitHub {
        owner = "irods";
        repo = "irods";
        rev = finalAttrs.version;
        hash = "sha256-SmN2FzeoA2/gjiDfGs2oifOVj0mK2WdQCgiSdIlENfk=";
        fetchSubmodules = true;
      };

      # fix build with recent llvm versions
      env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-register -Wno-deprecated-declarations";

      cmakeFlags = common.cmakeFlags or [ ] ++ [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${placeholder "out"}/lib -D_GLIBCXX_USE_CXX11_ABI=0"
        "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,${placeholder "out"}/lib"
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,${placeholder "out"}/lib"
      ];

      postPatch =
        common.postPatch
        + ''
          patchShebangs ./test
          substituteInPlace plugins/database/CMakeLists.txt --replace-fail "COMMAND cpp" "COMMAND ${gcc.cc}/bin/cpp"
          for file in unit_tests/cmake/test_config/*.cmake
          do
            substituteInPlace $file --replace-quiet "CATCH2}/include" "CATCH2}/include/catch2"
          done

          substituteInPlace server/auth/CMakeLists.txt --replace-fail SETUID ""
        '';

      meta = common.meta // {
        longDescription = common.meta.longDescription + "This package provides the servers and libraries.";
        mainProgram = "irodsServer";
      };
    }
  );

  # icommands (CLI) package, depends on the irods package
  irods-icommands = stdenv.mkDerivation (
    finalAttrs:
    common
    // {
      version = "4.3.3";
      pname = "irods-icommands";

      src = fetchFromGitHub {
        owner = "irods";
        repo = "irods_client_icommands";
        rev = finalAttrs.version;
        hash = "sha256-cc0V6BztJk3njobWt27VeJNmQUXyH6aBJkvYIDFEzWY=";
      };

      buildInputs = common.buildInputs ++ [ irods ];

      postPatch =
        common.postPatch
        + ''
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
        longDescription =
          common.meta.longDescription + "This package provides the CLI clients, called 'icommands'.";
      };
    }
  );
}
