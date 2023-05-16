{ buildGoModule
, fetchFromGitHub
, lib
, libXi
, libXrandr
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-uydt95mK0395dHvEno2SCnmKMJSkQ4TL7k7gnyoXlO0=";
=======
    sha256 = "sha256-dSBkRBT3crdoO3JB3kVSUDC0faRrxa/R5MF/3a9POxo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

<<<<<<< HEAD
  vendorHash = "sha256-SYh1MhJUrJKguR12L3yyxHoBB6ux6a4TUJyPvoYx7iU=";
=======
  vendorHash = "sha256-B/nxV9iHebe3v7VM+TTFGnAnPcBICtW+rDyrNNY6Ixw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
