<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, Carbon
, Cocoa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skhd";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "skhd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fnkWws/g4BdHKDRhqoCpdPFUavOHdk8R7h7H1dAdAYI=";
  };

  buildInputs = [
    Carbon
    Cocoa
  ];

  makeFlags = [
    "BUILD_PATH=$(out)/bin"
  ];
=======
{ lib, stdenv, fetchFromGitHub, Carbon }:

stdenv.mkDerivation rec {
  pname = "skhd";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x099979kgpim18r0vi9vd821qnv0rl3rkj0nd1nx3wljxgf7mrg";
  };

  buildInputs = [ Carbon ];

  makeFlags = [ "BUILD_PATH=$(out)/bin" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.skhd.plist} $out/Library/LaunchDaemons/org.nixos.skhd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.skhd.plist --subst-var out
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple hotkey daemon for macOS";
    homepage = "https://github.com/koekeishiya/skhd";
    license = lib.licenses.mit;
    mainProgram = "skhd";
    maintainers = with lib.maintainers; [ cmacrae lnl7 periklis khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
=======
  meta = with lib; {
    description = "Simple hotkey daemon for macOS";
    homepage = "https://github.com/koekeishiya/skhd";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae lnl7 periklis ];
    license = licenses.mit;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
