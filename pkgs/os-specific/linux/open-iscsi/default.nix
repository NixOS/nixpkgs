{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gettext
, utillinux, openisns, openssl, kmod, perl, systemd, pkgconf
}:

stdenv.mkDerivation rec {
  name = "open-iscsi-${version}";
  version = "2.0.877";

  nativeBuildInputs = [ autoconf automake gettext libtool perl pkgconf ];
  buildInputs = [ kmod openisns.lib openssl systemd utillinux ];

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = version;
    sha256 = "0v3dsrl34pdx0yl5jsanrpgg3vw466rl8k81hkshgq3a5mq5qhf6";
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

  meta = with stdenv.lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2;
    homepage = https://www.open-iscsi.com;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cleverca22 zaninime ];
  };
}
