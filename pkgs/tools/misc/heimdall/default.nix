{
  lib,
  stdenv,
  fetchFromSourcehut,
  cmake,
  libusb1,
  pkg-config,
  wrapQtAppsHook,
  zlib,
  enableGUI ? false,
  qtbase ? null,
}:

stdenv.mkDerivation rec {
  pname = "heimdall${lib.optionalString enableGUI "-gui"}";
  version = "2.2.1";

  src = fetchFromSourcehut {
    owner = "~grimler";
    repo = "Heimdall";
    rev = "v${version}";
    sha256 = "sha256-x+mDTT+oUJ4ffZOmn+UDk3+YE5IevXM8jSxLKhGxXSM=";
  };

  buildInputs =
    [
      libusb1
      zlib
    ]
    ++ lib.lists.optionals enableGUI [
      qtbase
      wrapQtAppsHook
    ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DDISABLE_FRONTEND=${if enableGUI then "OFF" else "ON"}"
    "-DLIBUSB_LIBRARY=${libusb1}"
  ];

  installPhase =
    lib.optionalString (stdenv.hostPlatform.isDarwin && enableGUI) ''
      mkdir -p $out/Applications
      mv bin/heimdall-frontend.app $out/Applications/heimdall-frontend.app
      wrapQtApp $out/Applications/heimdall-frontend.app/Contents/MacOS/heimdall-frontend
    ''
    + ''
      mkdir -p $out/{bin,share/doc/heimdall,lib/udev/rules.d}
      install -m755 -t $out/bin                bin/*
      install -m644 -t $out/lib/udev/rules.d   ../heimdall/60-heimdall.rules
      install -m644 ../README.md               $out/share/doc/heimdall/README.md
      install -m644 ../doc/*                   $out/share/doc/heimdall/
    '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~grimler/Heimdall";
    description = "Cross-platform tool suite to flash firmware onto Samsung Galaxy devices";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "heimdall${lib.optionalString enableGUI "-frontend"}";
  };
}
