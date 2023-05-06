{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, glib
, pkg-config
, gdk-pixbuf
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "popsicle";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "sha256-NqzuZmVabQ5WHOlBEsJhL/5Yet3TMSuo/gofSabCjTY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dbus-udisks2-0.3.0" = "sha256-VtwUUXVPyqvcOtphBH42CkRmW5jI+br9oDJ9wY40hsE=";
      "iso9660-0.1.0" = "sha256-A2C7DbtyJhOW+rjtAcO9YufQ5VjMfdypJAAmBlHpwn4=";
    };
  };

  nativeBuildInputs = [
    glib
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
