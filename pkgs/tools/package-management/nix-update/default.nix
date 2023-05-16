{ lib
, python3
, fetchFromGitHub
, nix
, nix-prefetch-git
, nixpkgs-fmt
, nixpkgs-review
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-update";
<<<<<<< HEAD
  version = "0.19.3";
=======
  version = "0.17.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-+WD+SV/L3TvksWBIg6jk+T0dUTNdp4VKONzdzVT+pac=";
=======
    hash = "sha256-W2vBKgdPOLGdAIxbHD4Qi4ivAabFSuu7ikvu5kItwN8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch-git nixpkgs-fmt nixpkgs-review ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help >/dev/null
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 zowoq ];
    platforms = platforms.all;
  };
}
