{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, indent
, perl
, argp-standalone
, fmt_9
, libev
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, withUsb ? stdenv.isLinux, libusb1
}:

stdenv.mkDerivation rec {
  pname = "knxd";
  version = "0.14.59";

  src = fetchFromGitHub {
    owner = "knxd";
    repo = "knxd";
    rev = version;
    hash = "sha256-m3119aD23XTViQJ2s7hwnJZ1ct4bcEFWuyUQajmqySQ=";
  };

  postPatch = ''
    sed -i '2i echo ${version}; exit' tools/version.sh
    sed -i '2i exit' tools/get_libfmt
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config indent perl ];

  buildInputs = [ fmt_9 libev ]
    ++ lib.optional withSystemd systemd
    ++ lib.optional withUsb libusb1
    ++ lib.optional stdenv.isDarwin argp-standalone;

  configureFlags = lib.optional (!withSystemd) "--disable-systemd"
    ++ lib.optional (!withUsb) "--disable-usb";

  installFlags = lib.optionals withSystemd [
    "systemdsystemunitdir=$(out)/lib/systemd/system"
    "systemdsysusersdir=$(out)/lib/sysusers.d"
  ];

  meta = with lib; {
    description = "Advanced router/gateway for KNX";
    homepage = "https://github.com/knxd/knxd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}

