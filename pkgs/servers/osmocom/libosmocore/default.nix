{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, gnutls
, libmnl
, liburing
, libusb1
, lksctp-tools
, pcsclite
, pkg-config
, python3
, talloc
}:

stdenv.mkDerivation rec {
  pname = "libosmocore";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    hash = "sha256-9b+wQoC3lOz7mlaxzSRIrXinRVoNj4UYW0ae+JBBKsE=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  propagatedBuildInputs = [
    talloc
    libmnl
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    gnutls
    liburing
    libusb1
    lksctp-tools
    pcsclite
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mog
      janik
    ];
  };
}
