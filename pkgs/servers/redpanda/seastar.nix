{ boost175
, c-ares
, cmake
, cryptopp
, fetchFromGitHub
, fmt_8
, gnutls
, hwloc
, lib
, libsystemtap
, libtasn1
, liburing
, libxfs
, lksctp-tools
, llvmPackages_15
, lz4
, ninja
, numactl
, openssl
, pkg-config
, python3
, ragel
, valgrind
, yaml-cpp
}:
let
  pname = "seastar";
  # see redpanda/cmake/dependencies.cmake
  version = "1e2ad26ac57c1130190f3f41237af0907aab17d8";
in
llvmPackages_15.stdenv.mkDerivation {
  inherit pname version;
  strictDeps = true;
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "seastar";
    # 23.3.x is a branch; in nix we have to pin to a particular commit
    rev = version; # "7ca1eaebf1fffed2858cec92b74aea1415c73913";
    sha256 = "sha256-nGDw9FwasVfHc1RuBH29SR17x5uNS0CbBsDwOdUvH0s=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    openssl
    pkg-config
    python3
    ragel
  ];
  buildInputs = [
    libsystemtap
    libxfs
  ];
  propagatedBuildInputs = [
    boost175
    c-ares
    gnutls
    cryptopp
    fmt_8
    hwloc
    libtasn1
    liburing
    lksctp-tools
    lz4
    numactl
    valgrind
    yaml-cpp
  ];
  # patches = [
  #   ./seastar-fixes.patch
  # ];
  postPatch = ''
    patchShebangs ./scripts/seastar-json2code.py
  '';
  cmakeFlags = [
    "-DSeastar_EXCLUDE_DEMOS_FROM_ALL=ON"
    "-DSeastar_EXCLUDE_TESTS_FROM_ALL=ON"

    # from redpanda/cmake/oss.cmake.in
    # NOTE: redpanda expects to be building seastar itself, whereas we build it in a separate package.
    "-DSeastar_CXX_FLAGS=-Wno-error"
    "-DSeastar_DPDK=OFF"
    "-DSeastar_APPS=OFF"
    "-DSeastar_DEMOS=OFF"
    "-DSeastar_DOCS=OFF"
    "-DSeastar_TESTING=OFF"
    "-DSeastar_API_LEVEL=6"
    "-DSeastar_CXX_DIALECT=c++20"
    # "-DSeastar_UNUSED_RESULT_ERROR=ON"
  ];
  doCheck = false;
  meta = with lib; {
    description = "High performance server-side application framework.";
    license = licenses.asl20;
    homepage = "https://seastar.io/";
    maintainers = with maintainers; [ avakhrenev ];
    platforms = platforms.unix;
  };
}
