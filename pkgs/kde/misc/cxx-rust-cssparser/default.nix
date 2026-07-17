{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  rustPlatform,
  rustc,
  cargo,
  cxx-rs,
  corrosion,
}:

mkKdeDerivation rec {
  pname = "cxx-rust-cssparser";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "cxx-rust-cssparser";
    tag = "v${version}";
    hash = "sha256-zYY9GmQb/Qbbu8AhOGHfrrQ563cIrnx9KMGkdledURw=";
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
    cxx-rs
  ];

  extraBuildInputs = [
    corrosion
  ];

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-CdOvP7VxS2JMD3MlRtc6QNUCGiVMGxiKayLG6vn6n+8=";
  };

  dontWrapQtApps = true;

  meta.license = with lib.licenses; [
    bsd2
    cc0
    lgpl2Only
    lgpl3Only
  ];
}
