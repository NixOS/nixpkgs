{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gettext
, util-linux, openisns, openssl, kmod, perl, systemd, pkgconf
}:

stdenv.mkDerivation rec {
  pname = "open-iscsi";
  version = "2.1.2";

  nativeBuildInputs = [ autoconf automake gettext libtool perl pkgconf ];
  buildInputs = [ kmod openisns.lib openssl systemd util-linux ];

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = version;
    sha256 = "0fazf2ighj0akrvcj3jm3kd6wl9lgznvr38g6icwfkqk7bykjkam";
  };

  DESTDIR = "$(out)";

  NIX_LDFLAGS = "-lkmod -lsystemd";
  NIX_CFLAGS_COMPILE = "-DUSE_KMOD";

  preConfigure = ''
    sed -i 's|/usr|/|' Makefile
  '';

  installFlags = [
    "install"
    "install_systemd"
  ];

  postInstall = ''
    cp usr/iscsistart $out/sbin/
    for f in $out/lib/systemd/system/*; do
      substituteInPlace $f --replace /sbin $out/bin
    done
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
