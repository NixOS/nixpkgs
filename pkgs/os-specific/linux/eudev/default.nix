{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gperf
, kmod
, pkg-config
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "eudev";
  version = "3.2.11";

  src = fetchFromGitHub {
    owner = "eudev-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W5nL4hicQ4fxz5rqoP+hhkE1tVn8lJZjMq4UaiXH6jc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gperf
    pkg-config
  ];

  buildInputs = [
    kmod
    util-linux
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  makeFlags = [
    "hwdb_bin=/var/lib/udev/hwdb.bin"
    "udevrulesdir=/etc/udev/rules.d"
    ];

  preInstall = ''
    # Disable install-exec-hook target,
    # as it conflicts with our move-sbin setup-hook

    sed -i 's;$(MAKE) $(AM_MAKEFLAGS) install-exec-hook;$(MAKE) $(AM_MAKEFLAGS);g' src/udev/Makefile
  '';

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
    "udevconfdir=$(out)/etc/udev"
    "udevhwdbbin=$(out)/var/lib/udev/hwdb.bin"
    "udevhwdbdir=$(out)/var/lib/udev/hwdb.d"
    "udevrulesdir=$(out)/var/lib/udev/rules.d"
  ];

  meta = with lib; {
    homepage = "https://github.com/eudev-project/eudev";
    description = "A fork of udev with the aim of isolating it from init";
    license = licenses.gpl2Plus ;
    maintainers = with maintainers; [ raskin AndersonTorres ];
    platforms = platforms.linux;
  };
}
