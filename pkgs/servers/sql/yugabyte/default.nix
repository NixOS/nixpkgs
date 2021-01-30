{
  boost165,
  cds,
  cmake,
  crcutil,
  crypt_blowfish,
  curl,
  fetchFromGitHub,
  glog,
  gmock,
  gperftools,
  hiredis,
  lib,
  libbacktrace,
  libev,
  libunwind,
  libuuid,
  lz4,
  nettools,
  openssl,
  protobuf,
  python3,
  snappy,
  squeasel,
  stdenv,
  which,
  zlib,
}: let
in stdenv.mkDerivation rec {
  pname = "yugabyte";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "yugabyte";
    repo = "yugabyte-db";
    rev = "v${version}";
    sha256 = "06zdqqgwa9nqmfp466zq4r3gdf545wlkz7nppv9af5vlpi2504mz";
    fetchSubmodules = true;
  };

  # YugabyteDB has a very custom and weird build process. It really wants to run by a script and download all of its dependencies. We don't want that so a lot of this is just poking the build scripts in funny ways because the upstream devs didn't want to do anything the standard way.

  nativeBuildInputs = [
    cmake
    nettools
    protobuf
    python3
    which
  ];
  buildInputs = [
    (lz4.override { enableStatic = true; })
    (boost165.override {
      enableMultiThreaded = true;
      enableSingleThreaded = true;
      enableStatic = true;
    })
    cds
    crcutil
    crypt_blowfish
    curl
    glog
    gmock
    gperftools
    hiredis
    libbacktrace
    libev
    libunwind
    libuuid
    openssl
    snappy
    squeasel
    zlib
  ];

  # Their build scripts *really* want the libs to be in the thirdparty dir.
  YB_THIRDPARTY_DIR = "/nix/store";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=release"
    # "-DYB_NO_REBUILD_THIRDPARTY=1"
    "-DCMAKE_FIND_DEBUG_MODE=1"
  ];

  # It is very picky what directory you build it in.
  dontUseCmakeBuildDir = true;
  cmakeDir = "../..";
  preConfigurePhases = "makeBuildDir";
  makeBuildDir = ''
    mkdir -p build/release-gcc-dynamic
    cd build/release-gcc-dynamic
  '';

  # YugabyteDB uses some compiler wrappers that do a lot of work. It seems infeasible to avoid them so we do some tricks to use them.
  patchPhase = ''
    patchShebangs build-support/validate_build_root.py

    patchShebangs build-support/compiler-wrappers/compiler-wrapper.sh
    cmakeFlags="-DCMAKE_C_COMPILER=$(realpath build-support/compiler-wrappers)/cc $cmakeFlags"
    cmakeFlags="-DCMAKE_CXX_COMPILER=$(realpath build-support/compiler-wrappers)/c++ $cmakeFlags"
  '';

  # nativeBuildInputs = lib.optionals icuEnabled [ pkg-config ];

  separateDebugInfo = true;

  passthru = {
    # tests.postgresql = nixosTests.postgresql-wal-receiver.${thisAttr};
  };

  meta = with lib; {
    homepage    = "https://www.postgresql.org";
    description = "A powerful, open source object-relational database system";
    license     = licenses.asl20;
    maintainers = with maintainers; [ kevincox ];
    platforms   = platforms.unix;
  };
}
