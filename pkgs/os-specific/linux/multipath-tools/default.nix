{ lib
, stdenv
, fetchFromGitHub
, coreutils

, perl
, pkg-config

, json_c
, libaio
, liburcu
, linuxHeaders
, lvm2
, readline
, systemd
, util-linuxMinimal

, cmocka
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    rev = "refs/tags/${version}";
    sha256 = "sha256-D2t1XsDa82m9JliL/i+68TZ/PKanXrtkN3w4gYrb/dM=";
  };

  postPatch = ''
    substituteInPlace create-config.mk \
      --replace-fail /bin/echo ${coreutils}/bin/echo

    substituteInPlace multipathd/multipathd.service.in \
      --replace-fail /sbin/multipathd "$out/bin/multipathd"
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    json_c
    libaio
    liburcu
    linuxHeaders
    lvm2
    readline
    systemd
    util-linuxMinimal # for libmount
  ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "systemd_prefix=$(out)"
    "kernel_incdir=${linuxHeaders}/include/"
    "man8dir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
  ];

  doCheck = true;
  preCheck = ''
    # skip test attempting to access /sys/dev/block
    substituteInPlace tests/Makefile --replace-fail ' devt ' ' '
  '';
  nativeCheckInputs = [ cmocka ];

  passthru.tests = { inherit (nixosTests) iscsi-multipath-root; };

  meta = with lib; {
    description = "Tools for the Linux multipathing storage driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
