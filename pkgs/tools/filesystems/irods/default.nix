{ stdenv, fetchurl, python, bzip2, zlib, autoconf, automake, cmake, gnumake, help2man , texinfo, libtool , cppzmq , libarchive, avro-cpp, boost, jansson, zeromq, openssl , pam, libiodbc, kerberos, gcc, libcxx, which }:

with stdenv;

let
  common = import ./common.nix {
    inherit stdenv bzip2 zlib autoconf automake cmake gnumake
            help2man texinfo libtool cppzmq libarchive jansson
            zeromq openssl pam libiodbc kerberos gcc libcxx
            boost avro-cpp which;
  };
in rec {

  # irods: libs and server package
  irods = stdenv.mkDerivation (common // rec {
    version = "4.2.0";
    prefix = "irods";
    name = "${prefix}-${version}";

    src = fetchurl {
      url = "https://github.com/irods/irods/releases/download/${version}/irods-${version}.tar.gz";
      sha256 = "b5c0d7209219629da139058ce462a237ecc22ad4dae613413a428961e4ff9d3e";
    };

    # Patches:
    # irods_root_path.patch : the root path is obtained by stripping 3 items of the path,
    #                         but we don't use /usr with nix, so remove only 2 items.
    patches = [ ./irods_root_path.patch ];

    preConfigure = common.preConfigure + ''
      patchShebangs ./test
      substituteInPlace plugins/database/CMakeLists.txt --replace "COMMAND cpp" "COMMAND ${gcc.cc}/bin/cpp"
      substituteInPlace cmake/server.cmake --replace "DESTINATION usr/sbin" "DESTINATION sbin"
      substituteInPlace cmake/server.cmake --replace "IRODS_DOC_DIR usr/share" "IRODS_DOC_DIR share"
      substituteInPlace cmake/runtime_library.cmake --replace "DESTINATION usr/lib" "DESTINATION lib"
      substituteInPlace cmake/development_library.cmake --replace "DESTINATION usr/lib" "DESTINATION lib"
      substituteInPlace cmake/development_library.cmake --replace "DESTINATION usr/include" "DESTINATION include"
      export cmakeFlags="$cmakeFlags
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,$out/lib
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,$out/lib
        "

      substituteInPlace cmake/server.cmake --replace SETUID ""
    '';

    meta = common.meta // {
      longDescription = common.meta.longDescription + ''
        This package provides the servers and libraries.'';
    };
  });


  # icommands (CLI) package, depends on the irods package
  irods-icommands = stdenv.mkDerivation (common // rec {
     version = "4.2.0";
     name = "irods-icommands-${version}";
     src = fetchurl {
       url = "http://github.com/irods/irods_client_icommands/archive/${version}.tar.gz";
       sha256 = "b581067c8139b5ef7897f15fc1fc79f69d2e784a0f36d96e8fa3cb260b6378ce";
     };

     buildInputs = common.buildInputs ++ [ irods ];

     propagateBuildInputs = [ boost ];

     preConfigure = common.preConfigure + ''
       patchShebangs ./bin
     '';

     cmakeFlags = common.cmakeFlags ++ [
       "-DCMAKE_INSTALL_PREFIX=${out}"
       "-DIRODS_DIR=${irods}/lib/irods/cmake"
       "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
       "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
       "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,${irods}/lib"
    ];

     meta = common.meta // {
       description = common.meta.description + " CLI clients";
       longDescription = common.meta.longDescription + ''
         This package provides the CLI clients, called 'icommands'.'';
     };
  });
}

