{ lib
, stdenv
, fetchFromGitHub
, coreutils
, pkg-config
, perl
, lvm2
, libaio
, readline
, systemd
, liburcu
, json_c
, linuxHeaders
, cmocka
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    rev = "refs/tags/${version}";
    sha256 = "sha256-CPvtnjzkyxKXrT8+YXaIgDA548h8X61+jCxMHKFfEyg=";
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

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c linuxHeaders ];

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
