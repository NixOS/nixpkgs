{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gettext
, utillinux, openisns, openssl, kmod, perl, systemd, pkgconf
}:

stdenv.mkDerivation rec {
  pname = "open-iscsi";
  version = "2.1.1";

  nativeBuildInputs = [ autoconf automake gettext libtool perl pkgconf ];
  buildInputs = [ kmod openisns.lib openssl systemd utillinux ];

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = version;
    sha256 = "1xa3mbid9mkajp8mr8jx6cymv0kd7yqs96jvff54n6wb9qhn9qll";
  };

  DESTDIR = "$(out)";

  NIX_LDFLAGS = "-lkmod -lsystemd";
  NIX_CFLAGS_COMPILE = "-DUSE_KMOD";

  preConfigure = ''
    sed -i 's|/usr|/|' Makefile
  '';

  postInstall = ''
    cp usr/iscsistart $out/sbin/
    $out/sbin/iscsistart -v
  '';

  postFixup = ''
    sed -i "s|/sbin/iscsiadm|$out/bin/iscsiadm|" $out/bin/iscsi_fw_login
  '';

  meta = with stdenv.lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2;
    homepage = "https://www.open-iscsi.com";
    platforms = platforms.linux;
    maintainers = with maintainers; [ cleverca22 zaninime ];
  };
}
