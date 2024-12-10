{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  glib,
  pkg-config,
  rustc,
  wrapGAppsHook3,
  gdk-pixbuf,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "popsicle";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "popsicle";
    rev = version;
    hash = "sha256-sWQNav7odvX+peDglLHd7Jrmvhm5ddFBLBla0WK7wcE=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dbus-udisks2-0.3.0" = "sha256-VtwUUXVPyqvcOtphBH42CkRmW5jI+br9oDJ9wY40hsE=";
      "iso9660-0.1.1" = "sha256-CXgvQvNbUWuNDpw92djkK1PZ2GbGj5KSNzkjAsNEDrU=";
      "pbr-1.1.1" = "sha256-KfzPhDiFj6jm1GASXnSoppkHrzoHst7v7cSNTDC/2FM=";
    };
  };

  nativeBuildInputs = [
    cargo
    glib
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook3
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
    maintainers = with maintainers; [
      _13r0ck
      figsoda
    ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
