<<<<<<< HEAD
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
    maintainers = with maintainers; [ ];
    inherit (nix.meta) platforms;
=======
{lib, stdenv, boost, cmake, pkg-config, nix, ... }:

stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  strictDeps = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost nix ];
  meta = with lib; {
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ chkno ];
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
