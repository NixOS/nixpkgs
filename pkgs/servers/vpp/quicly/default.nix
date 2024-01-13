{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, perl
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "quicly";
  version = "0.1.4-vpp";

  src = fetchFromGitHub {
    owner = "vpp-quic";
    repo = "quicly";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Sr5XSKslEhjNHHpV5pLEsi1/GwTatseQnmUaqMctA2I=";
  };

  patches = [
    ./0001-cmake-install.patch
    ./0002-cmake-install-picotls.patch
    ./0003-unused-is-late-ack.patch
  ];

  nativeBuildInputs = [
    cmake
    openssl
    perl
    pkg-config
  ];

  configurePhase = ''
    mkdir -p build-quicly build-picotls
    cmake -DWITH_DTRACE=OFF -DCMAKE_INSTALL_PREFIX:PATH=$out -S . -B build-quicly
    cd deps/picotls
    cmake -DWITH_DTRACE=OFF -DCMAKE_INSTALL_PREFIX:PATH=$out -S . -B ../../build-picotls
    cd $TMP/source
  '';

  buildPhase = ''
    make -j $NIX_BUILD_CORES -C build-quicly
    make picotls-core picotls-openssl -j $NIX_BUILD_CORES -C build-picotls
  '';

  installPhase = ''
    make -C build-quicly install
    make picotls-core picotls-openssl -C build-picotls install
  '';

  meta = with lib; {
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ cariandrum22 ];
    platforms = platforms.unix;
  };
}
