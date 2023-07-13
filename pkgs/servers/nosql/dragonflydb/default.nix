{ fetchFromGitHub
, fetchurl
, fetchpatch
, lib
, stdenv
, double-conversion
, re-flex
, gperftools
, c-ares
, rapidjson
, liburing
, xxHash
, gbenchmark
, glog
, gtest
, jemalloc
, gcc-unwrapped
, autoconf
, autoconf-archive
, automake
, cmake
, ninja
, boost
, libunwind
, libtool
, openssl
, libxml2
, bison
, zstd
, lz4
, abseil-cpp
}:

let
  pname = "dragonflydb";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "dragonfly";
    rev = "v${version}";
    hash = "sha256-D5HVa20P8qtG8IAjWw1PFHQG7MeC9b/LFNE4djaY8jU=";
    fetchSubmodules = true;
  };

  mimalloc = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v2.0.9";
    hash = "sha256-0gX0rEOWT6Lp5AyRyrK5GPTBvAqc5SxSaNJOc5GIgKc=";
  };

  # Needed exactly 5.4.4 for patch to work
  lua = fetchurl {
    url = "https://github.com/lua/lua/archive/refs/tags/v5.4.4.tar.gz";
    hash = "sha256-L/ibvqIqfIuRDWsAb1ukVZ7c9GiiVTfO35mI7ZD2tFA=";
  };

  jsoncons = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    rev = "v0.168.7";
    hash = "sha256-gZE/M92799MeWTwidwYbkQZH9JnavHNEd4pg+jjEBSU=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  prePatch = ''
    mkdir -p ./build/{third_party,_deps} ./build/third_party/cares

    ln -s ${double-conversion.src} ./build/third_party/dconv
    ln -s ${jsoncons} ./build/third_party/jsoncons
    ln -s ${rapidjson.src} ./build/third_party/rapidjson
    ln -s ${gtest.src} ./build/_deps/gtest-src
    ln -s ${gbenchmark.src} ./build/_deps/benchmark-src

    tar xvf ${c-ares.src} --strip-components=1 -C ./build/third_party/cares

    cp -R --no-preserve=mode,ownership ${lz4.src} ./build/third_party/lz4
    cp -R --no-preserve=mode,ownership ${gperftools.src} ./build/third_party/gperf
    cp -R --no-preserve=mode,ownership ${liburing.src} ./build/third_party/uring
    cp -R --no-preserve=mode,ownership ${xxHash.src} ./build/third_party/xxhash
    cp -R --no-preserve=mode,ownership ${mimalloc} ./build/third_party/mimalloc
    cp -R --no-preserve=mode,ownership ${glog.src} ./build/_deps/glog-src
    chmod u+x ./build/third_party/uring/configure
    cp ./build/third_party/xxhash/cli/xxhsum.{1,c} ./build/third_party/xxhash
  '';

  patches = [
    ./cmake-fixes.patch
    (fetchpatch {
      name = "apply-abseil-flags";
      url = "https://github.com/google/glog/commit/e433227305663c67d83fc5b2f6e62086c68545ad.patch";
      hash = "sha256-3vPLvbxuZzcTuR23Va2VzVQcM6yEhdp4XmKpbzveUtk=";
      stripLen = 1;
      extraPrefix = "build/_deps/glog-src/";
    })
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --subst-var-by luaUrl "file://${lua}"
    substituteInPlace helio/cmake/third_party.cmake \
      --subst-var-by jemallocUrl "file://${jemalloc.src}"
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    cmake
    ninja
    bison
    re-flex
  ];

  buildInputs = [
    abseil-cpp
    boost
    libunwind
    libtool
    openssl
    libxml2
    zstd
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    # re-flex doesn't include a cmake-config/pkgconfig file
    "-DREFLEX_LIBRARY=${re-flex}/lib/libreflex.a"
    "-DREFLEX_INCLUDE=${re-flex}/include"
  ];

  ninjaFlags = [ "dragonfly" ];

  doCheck = false;
  dontUseNinjaInstall = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./dragonfly $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern replacement for Redis and Memcached";
    homepage = "https://dragonflydb.io/";
    license = licenses.bsl11;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yureien ];
  };
}
