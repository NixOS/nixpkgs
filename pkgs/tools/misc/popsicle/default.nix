{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, glib
, pkg-config
, rustc
, wrapGAppsHook
, gdk-pixbuf
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "popsicle";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "popsicle";
    rev = version;
    hash = "sha256-2RkptzUX0G17HJMTHVqjbRHIIc8+NcSRUvE+S9nmtLs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dbus-udisks2-0.3.0" = "sha256-VtwUUXVPyqvcOtphBH42CkRmW5jI+br9oDJ9wY40hsE=";
      "iso9660-0.1.1" = "sha256-amegb0ULjYHGTHJoyXlqkyhky10JjmoR1iR4grKzyHY=";
    };
  };

  nativeBuildInputs = [
    cargo
    glib
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
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
