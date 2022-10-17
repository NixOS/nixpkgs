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
  # If not null, the builder will
  # move "$out/etc" to "$out/etc.orig" and symlink "$out/etc" to externalEtc.
, externalEtc ? "/etc"
}:

stdenv.mkDerivation rec {
  pname = "xrootd";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-a8qw8uHxd7OLMMq+HPMB36O0Yjctlnf8DkfEdMvc1NQ=";
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

  # https://github.com/xrootd/xrootd/blob/master/packaging/rhel/xrootd.spec.in#L665-L675=
  postInstall = ''
    mkdir -p "$out/lib/tmpfiles.d"
    install -m 644 -T ../packaging/rhel/xrootd.tmpfiles "$out/lib/tmpfiles.d/xrootd.conf"
    mkdir -p "$out/etc/xrootd"
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/*.cfg
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/client.conf
    mkdir -p "$out/etc/xrootd/client.plugins.d"
    install -m 644 -t "$out/etc/xrootd/client.plugins.d" ../packaging/common/client-plugin.conf.example
    mkdir -p "$out/etc/logrotate.d"
    install -m 644 -T ../packaging/common/xrootd.logrotate "$out/etc/logrotate.d/xrootd"
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/lib/systemd/system"
    install -m 644 -t "$out/lib/systemd/system" ../packaging/common/*.service ../packaging/common/*.socket
  '';

  cmakeFlags = lib.optionals enableTests [
    "-DENABLE_TESTS=TRUE"
  ];

  postFixup = lib.optionalString (externalEtc != null) ''
    mv "$out"/etc{,.orig}
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  meta = with lib; {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
