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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    rev = "refs/tags/${version}";
    sha256 = "sha256-X4sAMGn4oBMY3cQkVj1dMcrDF7FgMl8SbZeUnCCOY6Q=";
  };

  postPatch = ''
    substituteInPlace create-config.mk \
      --replace /bin/echo ${coreutils}/bin/echo

    substituteInPlace multipathd/multipathd.service \
      --replace /sbin/multipathd "$out/bin/multipathd"

    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
    sed -i -e "s,GZIP,GZ," \
      $(find * -name Makefile\*)

    sed '1i#include <assert.h>' -i tests/{util,vpd}.c
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
    substituteInPlace tests/Makefile --replace ' devt ' ' '
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
