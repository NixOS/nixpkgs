{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, gettext, libxslt, docbook_xsl_ns
, libcap, systemd, libidn2
}:

with stdenv.lib;

let
  version = "20200821";
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
    sha256 = "1jhbcz75a4ij1myyyi110ma1d8d5hpm3scz9pyw7js6qym50xvh4";
  };

  mesonFlags = [
    "-DBUILD_RARPD=true"
    "-DBUILD_TRACEROUTE6=true"
    "-DBUILD_TFTPD=true"
    "-DNO_SETCAP_OR_SUID=true"
    "-Dsystemdunitdir=etc/systemd/system"
  ]
    # Disable idn usage w/musl (https://github.com/iputils/iputils/pull/111):
    ++ optional stdenv.hostPlatform.isMusl "-DUSE_IDN=false";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxslt.bin docbook_xsl_ns ];
  buildInputs = [ libcap systemd ]
    ++ optional (!stdenv.hostPlatform.isMusl) libidn2;

  meta = {
    description = "A set of small useful utilities for Linux networking";
    inherit (src.meta) homepage;
    changelog = "https://github.com/iputils/iputils/releases/tag/s${version}";
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
