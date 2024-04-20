{ lib
, stdenv
, boost
, cmake
, pkg-config
, installShellFiles
, nix
}:

stdenv.mkDerivation {
  name = "nixos-option";

  src = ./.;
  postInstall = ''
    installManPage ${./nixos-option.8}
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    boost
    nix
  ];
  cmakeFlags = [
    "-DNIX_DEV_INCLUDEPATH=${nix.dev}/include/nix"
  ];

  meta = with lib; {
    license = licenses.lgpl2Plus;
    mainProgram = "nixos-option";
    maintainers = with maintainers; [ ];
    inherit (nix.meta) platforms;
  };
}
