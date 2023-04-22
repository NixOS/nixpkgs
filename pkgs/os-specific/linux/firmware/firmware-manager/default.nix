{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, xz
, pkg-config
, openssl
, dbus
, glib
, udev
, cairo
, pango
, atk
, gdk-pixbuf
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "firmware-manager";
  version = "unstable-2022-12-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "9be8160346689bd74f95db7897884a91fa48afe3";
    sha256 = "sha256-zZk2RVghhKxETSVv/Jtv8Wq6+ITx/BudE/o7h4jKk5M=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecflash-0.1.0" = "sha256-W613wbW54R65/rs6oiPAH/qov2OVEjMMszpUJdX4TxI=";
      "system76-firmware-1.0.45" = "sha256-2ougRwPvdet5nIKcFGElBRrsxukW8jMNCBw3C68VJ+Q=";
    };
  };

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)/etc' '$(DESTDIR)$(prefix)/etc'
  '';

  nativeBuildInputs = with rustPlatform; [
    rust.cargo
    rust.rustc
    pkg-config
    cargoSetupHook
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
