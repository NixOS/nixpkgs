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
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "unstable-2022-12-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    hash = "sha256-Q+LJJ4xK583fAcwuOFykt6GKT0rVJgmTt+zUX4o4Tm4=";
=======
    rev = "9be8160346689bd74f95db7897884a91fa48afe3";
    sha256 = "sha256-zZk2RVghhKxETSVv/Jtv8Wq6+ITx/BudE/o7h4jKk5M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecflash-0.1.0" = "sha256-W613wbW54R65/rs6oiPAH/qov2OVEjMMszpUJdX4TxI=";
<<<<<<< HEAD
      "system76-firmware-1.0.51" = "sha256-+GPz7uKygGnFUptQEGYWkEdHgxBc65kLZqpwZqtwets=";
=======
      "system76-firmware-1.0.45" = "sha256-2ougRwPvdet5nIKcFGElBRrsxukW8jMNCBw3C68VJ+Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
