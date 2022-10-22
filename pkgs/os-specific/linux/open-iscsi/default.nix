{ lib, stdenv, fetchFromGitHub, automake, autoconf, libtool, gettext
, util-linux, open-isns, openssl, kmod, perl, systemd, pkgconf, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "open-iscsi";
  version = "2.1.7";

  nativeBuildInputs = [ autoconf automake gettext libtool perl pkgconf ];
  buildInputs = [ kmod open-isns.lib openssl systemd util-linux ];

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = version;
    sha256 = "sha256-R1ttHHxVSQ5TGtWVy4I9BAmEJfcRhKRD5jThoeddjUw=";
  };

  DESTDIR = "$(out)";

  NIX_LDFLAGS = "-lkmod -lsystemd";
  NIX_CFLAGS_COMPILE = "-DUSE_KMOD";

  preConfigure = ''
    # Remove blanket -Werror. Fails for minor error on gcc-11.
    substituteInPlace usr/Makefile --replace ' -Werror ' ' '
  '';

  # avoid /usr/bin/install
  makeFlags = [
    "INSTALL=install"
    "SED=sed"
    "prefix=/"
    "manprefix=/share"
  ];

  installFlags = [
    "install"
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

  passthru.tests = { inherit (nixosTests) iscsi-root iscsi-multipath-root; };

  meta = with lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2Plus;
    homepage = "https://www.open-iscsi.com";
    platforms = platforms.linux;
    maintainers = with maintainers; [ cleverca22 zaninime ];
  };
}
