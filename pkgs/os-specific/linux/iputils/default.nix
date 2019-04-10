{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, gettext, libxslt, docbook_xsl_ns
, libcap, nettle, libidn2, openssl, systemd
}:

with stdenv.lib;

let
  time = "20190324";
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
    sha256 = "0b755gv3370c0rrphx14mrsqjb396zqnsm9lsws842a4k4zrqmvi";
  };

  # ninfod cannot be build with nettle yet:
  patches =
    [ ./build-ninfod-with-openssl.patch
      (fetchpatch { # tracepath: fix musl build, again
        url = "https://github.com/iputils/iputils/commit/c9aca1b53324bcd1b5a2de5c645813f80eccd016.patch";
        sha256 = "0faqgkqbi57cyx1zgzzy6xgd24xr0iawix7mjs47j92ra9gw90cz";
      })
      (fetchpatch { # doc: Use namespace correctly
        url = "https://github.com/iputils/iputils/commit/c503834519d21973323980850431101f90e663ef.patch";
        sha256 = "1yp6b6403ddccbhfzsb36cscxd36d4xb8syc1g02a18xkswiwf09";
      })
    ];

  mesonFlags =
    [ "-DUSE_CRYPTO=nettle"
      "-DBUILD_RARPD=true"
      "-DBUILD_TRACEROUTE6=true"
      "-Dsystemdunitdir=etc/systemd/system"
    ]
    ++ optional (!withNinfod) "-DBUILD_NINFOD=false"
    # Disable idn usage w/musl (https://github.com/iputils/iputils/pull/111):
    ++ optional stdenv.hostPlatform.isMusl "-DUSE_IDN=false";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxslt.bin docbook_xsl_ns libcap ];
  buildInputs = [ libcap nettle systemd ]
    ++ optional (!stdenv.hostPlatform.isMusl) libidn2
    ++ optional withNinfod openssl; # TODO: Build with nettle

  meta = {
    homepage = https://github.com/iputils/iputils;
    description = "A set of small useful utilities for Linux networking";
    license = with licenses; [ gpl2Plus bsd3 sunAsIsLicense ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos lheckemann ];
  };
}
