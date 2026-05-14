{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
}:

stdenv.mkDerivation {
  pname = "ofono-phonesim";
  version = "unstable-2019-11-18";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/network/ofono/phonesim.git/snapshot/phonesim-adf231a84cd3708b825dc82c56e841dd7e3b4541.tar.gz";
    sha256 = "1840914sz46l8h2jwa0lymw6dvgj72wq9bhp3k4v4rk6masbf6hp";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  makeFlags = [
    "MOC=${qtbase.dev}/bin/moc"
    "UIC=${qtbase.dev}/bin/uic"
  ];

  meta = {
    description = "Phone Simulator for modem testing";
    mainProgram = "phonesim";
    homepage = "https://01.org/ofono";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
