{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, perl
, lvm2
, libaio
, readline
, systemd
, liburcu
, json_c
, kmod
, cmocka
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    rev = "refs/tags/${version}";
    sha256 = "sha256-pIGeZ+jB+6GqkfVN83axHIuY/BobQ+zs+tH+MkLIln0=";
  };

  postPatch = ''
    substituteInPlace libmultipath/Makefile \
      --replace /usr/include/libdevmapper.h ${lib.getDev lvm2}/include/libdevmapper.h

    # systemd-udev-settle.service is deprecated.
    substituteInPlace multipathd/multipathd.service \
      --replace /sbin/modprobe ${lib.getBin kmod}/sbin/modprobe \
      --replace /sbin/multipathd "$out/bin/multipathd" \
      --replace " systemd-udev-settle.service" ""

    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
    sed -i -e "s,GZIP,GZ," \
      $(find * -name Makefile\*)
  '';

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "man8dir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "SYSTEMDPATH=lib"
  ];

  doCheck = true;
  preCheck = ''
    # skip test attempting to access /sys/dev/block
    substituteInPlace tests/Makefile --replace ' devt ' ' '
  '';
  checkInputs = [ cmocka ];

  passthru.tests = { inherit (nixosTests) iscsi-multipath-root; };

  meta = with lib; {
    description = "Tools for the Linux multipathing storage driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
