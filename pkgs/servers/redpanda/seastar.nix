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
, llvmPackages_14
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
  version = "22.11.0";
in
llvmPackages_14.stdenv.mkDerivation {
  inherit pname version;
  strictDeps = true;
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "seastar";
    rev = "30d3a28bde08d2228b4e560c173b89fdd94c3f05";
    sha256 = "sha256-Xzu7AJMkvE++BGEqluod3fwMEIpDnbCczmlEad0/4v4=";
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
  patches = [
    ./seastar-fixes.patch
  ];
  postPatch = ''
    patchShebangs ./scripts/seastar-json2code.py
  '';
  cmakeFlags = [
    "-DSeastar_EXCLUDE_DEMOS_FROM_ALL=ON"
    "-DSeastar_EXCLUDE_TESTS_FROM_ALL=ON"
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
