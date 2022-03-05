{ lib, stdenv, bzip2, zlib, autoconf, automake, cmake, gnumake, help2man, texinfo, libtool, cppzmq, libarchive
, avro-cpp, boost, jansson, zeromq, openssl, pam, libiodbc, libkrb5, gcc, libcxx, which, catch2, nanodbc, fmt
, nlohmann_json, spdlog }:

# Common attributes of irods packages

{
  nativeBuildInputs = [ autoconf automake cmake gnumake help2man texinfo which gcc ];
  buildInputs = [ bzip2 zlib libtool cppzmq libarchive avro-cpp jansson zeromq openssl pam libiodbc libkrb5 boost
                  libcxx catch2 nanodbc fmt nlohmann_json spdlog ];

  cmakeFlags = [
    "-DIRODS_EXTERNALS_FULLPATH_CLANG=${stdenv.cc}"
    "-DIRODS_EXTERNALS_FULLPATH_CLANG_RUNTIME=${stdenv.cc}"
    "-DIRODS_EXTERNALS_FULLPATH_ARCHIVE=${libarchive.lib}"
    "-DIRODS_EXTERNALS_FULLPATH_AVRO=${avro-cpp}"
    "-DIRODS_EXTERNALS_FULLPATH_BOOST=${boost}"
    "-DIRODS_EXTERNALS_FULLPATH_JANSSON=${jansson}"
    "-DIRODS_EXTERNALS_FULLPATH_ZMQ=${zeromq}"
    "-DIRODS_EXTERNALS_FULLPATH_CPPZMQ=${cppzmq}"
    "-DIRODS_EXTERNALS_FULLPATH_CATCH2=${catch2}"
    "-DIRODS_EXTERNALS_FULLPATH_NANODBC=${nanodbc}"
    "-DIRODS_EXTERNALS_FULLPATH_FMT=${fmt}"
    "-DIRODS_EXTERNALS_FULLPATH_JSON=${nlohmann_json}"
    "-DIRODS_EXTERNALS_FULLPATH_SPDLOG=${spdlog}"
    "-DIRODS_LINUX_DISTRIBUTION_NAME=nix"
    "-DIRODS_LINUX_DISTRIBUTION_VERSION_MAJOR=1.0"
    "-DCPACK_GENERATOR=TGZ"
    "-DCMAKE_CXX_FLAGS=-I${lib.getDev libcxx}/include/c++/v1"
  ];

  postPatch = ''
    patchShebangs ./packaging ./scripts
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION usr/bin" "DESTINATION bin" \
      --replace "INCLUDE_DIRS usr/include/" "INCLUDE_DIRS include/" \
      --replace "DESTINATION usr/lib/" "DESTINATION lib/" \
      --replace "{IRODS_EXTERNALS_FULLPATH_JSON}/include" "{IRODS_EXTERNALS_FULLPATH_JSON}/include/nlohmann"
    export cmakeFlags="$cmakeFlags
      -DCMAKE_INSTALL_PREFIX=$out
    "
  '';

  meta = with lib; {
    description = "Integrated Rule-Oriented Data System (iRODS)";
    longDescription = ''
      The Integrated Rule-Oriented Data System (iRODS) is open source data management
      software used by research organizations and government agencies worldwide.
      iRODS is released as a production-level distribution aimed at deployment in mission
      critical environments.  It virtualizes data storage resources, so users can take
      control of their data, regardless of where and on what device the data is stored.
      As data volumes grow and data services become more complex, iRODS is increasingly
      important in data management. The development infrastructure supports exhaustive
      testing on supported platforms; plug-in support for microservices, storage resources,
      drivers, and databases; and extensive documentation, training and support services.'';
    homepage = "https://irods.org";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}
