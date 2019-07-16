{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, gettext, libxslt, docbook_xsl_ns
, libcap, nettle, libidn2, openssl, systemd
}:

with stdenv.lib;

let
  time = "20190515";
  # ninfod probably could build on cross, but the Makefile doesn't pass --host
  # etc to the sub configure...
  withNinfod = stdenv.hostPlatform == stdenv.buildPlatform;
  sunAsIsLicense = {
    fullName = "AS-IS, SUN MICROSYSTEMS license";
    url = "https://github.com/iputils/iputils/blob/s${time}/rdisc.c";
  };
in stdenv.mkDerivation {
  name = "iputils-${time}";

  src = fetchFromGitHub {
    owner = "iputils";
    repo = "iputils";
    rev = "s${time}";
    sha256 = "1k2wzgk0d47d1g9k8c1a5l24ml8h8xxz1vrs0vfbyxr7qghdhn4i";
  };

  # ninfod cannot be build with nettle yet:
  patches =
    [ ./build-ninfod-with-openssl.patch
      (fetchpatch { # build-sys/doc: Fix the dependency on xsltproc
        url = "https://github.com/iputils/iputils/commit/3b013f271931c3fe771e5a2c591f35d617de90f3.patch";
        sha256 = "0ilhlgiqdflry7km3ik8i4h1yymm5f5zmwyl5r029q7x1p8kinfw";
      })
      (fetchpatch { # build-sys: Make setcap really optional
        url = "https://github.com/iputils/iputils/commit/473be6467f995865244e7e68b2fa587a4ee79551.patch";
        sha256 = "0781147qaf0jwa177jbmh474r8hqs0jwgi5vgx9csb43jzdm8hqf";
      })
    ];

  mesonFlags =
    [ "-DUSE_CRYPTO=nettle"
      "-DBUILD_RARPD=true"
      "-DBUILD_TRACEROUTE6=true"
      "-DNO_SETCAP_OR_SUID=true"
      "-Dsystemdunitdir=etc/systemd/system"
    ]
    ++ optional (!withNinfod) "-DBUILD_NINFOD=false"
    # Disable idn usage w/musl (https://github.com/iputils/iputils/pull/111):
    ++ optional stdenv.hostPlatform.isMusl "-DUSE_IDN=false";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxslt.bin docbook_xsl_ns ];
  buildInputs = [ libcap nettle systemd ]
    ++ optional (!stdenv.hostPlatform.isMusl) libidn2
    ++ optional withNinfod openssl; # TODO: Build with nettle

  meta = {
    homepage = https://github.com/iputils/iputils;
    description = "A set of small useful utilities for Linux networking";
    license = with licenses; [ gpl2Plus bsd3 sunAsIsLicense ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos lheckemann ];

    longDescription = ''
      A set of small useful utilities for Linux networking including:

      arping
      clockdiff
      ninfod
      ping
      rarpd
      rdisc
      tftpd
      tracepath
      traceroute6
    '';
  };
}
