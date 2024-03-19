{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, glib
, libkrb5
, libnl
, libtool
, pkg-config
, withKerberos ? false
}:

stdenv.mkDerivation rec {
  pname = "ksmbd-tools";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "cifsd-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-1Htky39oggDqPYSbF4it2UMIxuoLp0aK+IjGojPgaiU=";
  };

  buildInputs = [ glib libnl ] ++ lib.optional withKerberos libkrb5;

  nativeBuildInputs = [ meson ninja libtool pkg-config ];
  patches = [ ./0001-skip-installing-example-configuration.patch ];
  mesonFlags = [
    "-Drundir=/run"
    "-Dsystemdsystemunitdir=lib/systemd/system"
    "--sysconfdir /etc"
  ];

  meta = with lib; {
    description = "Userspace utilities for the ksmbd kernel SMB server";
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/cifs/ksmbd.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elohmeier ];
  };
}
