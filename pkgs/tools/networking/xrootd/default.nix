{ lib
, stdenv
, callPackage
, fetchFromGitHub
, cmake
, cppunit
, pkg-config
, curl
, fuse
, libkrb5
, libuuid
, libxml2
, openssl
, readline
, systemd
, voms
, zlib
, enableTests ? true
}:

stdenv.mkDerivation rec {
  pname = "xrootd";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BlMYm4ffSpUxqMjlDVZC59KOuLvwsk/BeBB3VBjAwjs=";
  };

  outputs = [ "bin" "out" "dev" "man" ];

  passthru.tests = lib.optionalAttrs enableTests {
    test-runner = callPackage ./test-runner.nix { };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    libkrb5
    libuuid
    libxml2
    openssl
    readline
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    fuse
    systemd
    voms
  ]
  ++ lib.optionals enableTests [
    cppunit
  ];

  preConfigure = ''
    patchShebangs genversion.sh

    # Manually apply part of
    # https://github.com/xrootd/xrootd/pull/1619
    # Remove after the above PR is merged.
    sed -i 's/set\((\s*CMAKE_INSTALL_[A-Z_]\+DIR\s\+"[^"]\+"\s*)\)/define_default\1/g' cmake/XRootDOSDefs.cmake
  '';

  cmakeFlags = lib.optionals enableTests [
    "-DENABLE_TESTS=TRUE"
  ];

  meta = with lib; {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
