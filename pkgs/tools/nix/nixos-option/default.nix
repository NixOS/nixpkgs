{
  lib,
  stdenv,
  boost,
  meson,
  ninja,
  pkg-config,
  installShellFiles,
  nix,
  nixosTests,
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

  passthru.tests.installer-simpleUefiSystemdBoot = nixosTests.installer.simpleUefiSystemdBoot;

  meta = with lib; {
    license = licenses.lgpl2Plus;
    mainProgram = "nixos-option";
    maintainers = [ ];
    inherit (nix.meta) platforms;
  };
}
