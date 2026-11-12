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
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "cxx-rust-cssparser";
    tag = "v${version}";
    hash = "sha256-0GO299lTzKh6YwNytuDHu+JlBT+d9E4R1VDWrXueVlM=";
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
    hash = "sha256-Ukb/LbMMHfeazHiTpwKKAZV2nx5tXZZxJYbLGe9RaVM=";
  };

  dontWrapQtApps = true;

  meta.license = with lib.licenses; [
    bsd2
    cc0
    lgpl2Only
    lgpl3Only
  ];
}
