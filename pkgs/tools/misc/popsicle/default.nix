{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, rustPlatform
, cargo
, glib
, pkg-config
, rustc
, wrapGAppsHook
, gdk-pixbuf
, gtk3
=======
, cargo
, rustPlatform
, rustc
, glib
, pkg-config
, gdk-pixbuf
, gtk3
, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "popsicle";
<<<<<<< HEAD
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "popsicle";
    rev = version;
    hash = "sha256-2RkptzUX0G17HJMTHVqjbRHIIc8+NcSRUvE+S9nmtLs=";
=======
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "sha256-NqzuZmVabQ5WHOlBEsJhL/5Yet3TMSuo/gofSabCjTY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dbus-udisks2-0.3.0" = "sha256-VtwUUXVPyqvcOtphBH42CkRmW5jI+br9oDJ9wY40hsE=";
<<<<<<< HEAD
      "iso9660-0.1.1" = "sha256-amegb0ULjYHGTHJoyXlqkyhky10JjmoR1iR4grKzyHY=";
=======
      "iso9660-0.1.0" = "sha256-A2C7DbtyJhOW+rjtAcO9YufQ5VjMfdypJAAmBlHpwn4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    cargo
    glib
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
=======
    glib
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rustc
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "Multiple USB File Flasher";
    homepage = "https://github.com/pop-os/popsicle";
    changelog = "https://github.com/pop-os/popsicle/releases/tag/${version}";
    maintainers = with maintainers; [ _13r0ck figsoda ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
