{ lib, stdenv, fetchurl, fetchpatch, pkg-config, perl, lvm2, libaio, gzip, readline, systemd, liburcu, json_c, kmod, nixosTests }:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.8.3";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=snapshot;h=refs/tags/${version};sf=tgz";
    sha256 = "1mgjylklh1cx8px8ffgl12kyc0ln3445vbabd2sy8chq31rpiiq8";
  };

  patches = [
    # fix build with json-c 0.14 https://www.redhat.com/archives/dm-devel/2020-May/msg00261.html
    ./json-c-0.14.patch

    # pull upstream fix for -fno-common toolchains like clang-12
    (fetchpatch {
        name = "fno-common.patch";
        url = "https://github.com/opensvc/multipath-tools/commit/23a9247fa89cd0c84fe7e0f32468fd698b1caa48.patch";
        sha256 = "10hq0g2jfkfbmwhm4x4q5cgsswj30lm34ib153alqzjzsxc1hqjk";
    })
  ];

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

  nativeBuildInputs = [ gzip pkg-config perl ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "man8dir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "SYSTEMDPATH=lib"
  ];

  passthru.tests = { inherit (nixosTests) iscsi-multipath-root; };

  meta = with lib; {
    description = "Tools for the Linux multipathing driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
