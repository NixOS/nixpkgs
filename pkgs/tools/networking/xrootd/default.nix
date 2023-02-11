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
, libxcrypt
, libxml2
, openssl
, readline
, systemd
, voms
, zlib
, enableTests ? stdenv.isLinux
  # If not null, the builder will
  # move "$out/etc" to "$out/etc.orig" and symlink "$out/etc" to externalEtc.
, externalEtc ? "/etc"
}:

stdenv.mkDerivation rec {
  pname = "xrootd";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-2zVCOcjL8TUbo38Dx7W8431ziouzuAdCfogsIMSOOmQ=";
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
    libxcrypt
    libxml2
    openssl
    readline
    zlib
    fuse
  ]
  ++ lib.optionals stdenv.isLinux [
    systemd
    voms
  ]
  ++ lib.optionals enableTests [
    cppunit
  ];

  preConfigure = ''
    patchShebangs genversion.sh
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
