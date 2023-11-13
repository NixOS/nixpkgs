{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cargo
, pkg-config
, rustc
, openssl
, udev
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "firmware-manager";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    hash = "sha256-Q+LJJ4xK583fAcwuOFykt6GKT0rVJgmTt+zUX4o4Tm4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecflash-0.1.0" = "sha256-W613wbW54R65/rs6oiPAH/qov2OVEjMMszpUJdX4TxI=";
      "system76-firmware-1.0.51" = "sha256-+GPz7uKygGnFUptQEGYWkEdHgxBc65kLZqpwZqtwets=";
    };
  };

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)/etc' '$(DESTDIR)$(prefix)/etc'
  '';

  nativeBuildInputs = [
    cargo
    rustc
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook
  ];

  buildInputs = [
    openssl
    gtk3
    udev
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Graphical frontend for firmware management";
    homepage = "https://github.com/pop-os/firmware-manager";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.shlevy ];
    platforms = lib.platforms.linux;
  };
}
