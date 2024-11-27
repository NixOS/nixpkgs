{
  lib,
  stdenv,
  boost,
  meson,
  ninja,
  pkg-config,
  installShellFiles,
  nix,
}:

stdenv.mkDerivation {
  name = "nixos-option";

  src = ./.;

  postInstall = ''
    installManPage ../nixos-option.8
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    boost
    nix
  ];

  meta = with lib; {
    license = licenses.lgpl2Plus;
    mainProgram = "nixos-option";
    maintainers = [ ];
    inherit (nix.meta) platforms;
  };
}
