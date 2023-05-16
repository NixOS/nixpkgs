<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.7";
=======
{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8FVXVawmaCgnsexnNRw53tVR2a2fRyDK+h959Ezw7Zg=";
  };

  vendorHash = "sha256-mudJN7rYWpdv2X4hrYjPBtEILyrdext4q+maDK1dC44=";
=======
    sha256 = "sha256-Xcj+1zSAgizj5e1VY77ma8i9XEuDaebyNZJcFCsNYwI=";
  };

  vendorSha256 = "sha256-vPVfI2MXrUEvx/jlt6A3EEHiyiy4R3FSw3UnF76ZZho=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "bluetuith";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
