{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, gettext, libxslt, docbook_xsl_ns
, libcap, nettle, libidn2, systemd
}:

with stdenv.lib;

let
  version = "20190709";
  sunAsIsLicense = {
    fullName = "AS-IS, SUN MICROSYSTEMS license";
    url = "https://github.com/iputils/iputils/blob/s${version}/rdisc.c";
  };
in stdenv.mkDerivation rec {
  pname = "iputils";
  inherit version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "s${version}";
    sha256 = "04bp4af15adp79ipxmiakfp0ij6hx5qam266flzbr94pr8z8l693";
  };

  mesonFlags =
    [ "-DUSE_CRYPTO=nettle"
      "-DBUILD_RARPD=true"
      "-DBUILD_TRACEROUTE6=true"
      "-DNO_SETCAP_OR_SUID=true"
      "-Dsystemdunitdir=etc/systemd/system"
    ]
    # Disable idn usage w/musl (https://github.com/iputils/iputils/pull/111):
    ++ optional stdenv.hostPlatform.isMusl "-DUSE_IDN=false";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxslt.bin docbook_xsl_ns ];
  buildInputs = [ libcap nettle systemd ]
    ++ optional (!stdenv.hostPlatform.isMusl) libidn2;

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
