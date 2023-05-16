{ stdenv
, lib
, fetchFromGitHub
, hwdata
, gtk2
, pkg-config
<<<<<<< HEAD
, gettext
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sqlite # compile GUI
, withGUI ? false
}:

stdenv.mkDerivation rec {
  pname = "lshw";
<<<<<<< HEAD
  # FIXME: when switching to a stable release:
  # Fix repology.org by not including the prefixed B, otherwise the `pname` attr
  # gets filled as `lshw-B.XX.XX` in `nix-env --query --available --attr nixpkgs.lshw --meta`
  # See https://github.com/NixOS/nix/pull/4463 for a definitive fix
  version = "unstable-2023-03-20";
=======
  # Fix repology.org by not including the prefixed B, otherwise the `pname` attr
  # gets filled as `lshw-B.XX.XX` in `nix-env --query --available --attr nixpkgs.lshw --meta`
  # See https://github.com/NixOS/nix/pull/4463 for a definitive fix
  version = "02.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lyonel";
    repo = pname;
<<<<<<< HEAD
    rev = "b4e067307906ec6f277cce5c8a882f5edd03cbbc";
    #rev = "B.${version}";
    sha256 = "sha256-ahdaQeYZEFCVxwAMJPMB9bfo3ndIiqFyM6OghXwtm1A=";
  };

  nativeBuildInputs = [ pkg-config gettext ];
=======
    rev = "B.${version}";
    sha256 = "sha256-PzbNGc1pPiPLWWgTeWoNfAo+SsXgi1HcjnXfYXA9S0I=";
  };

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ hwdata ]
    ++ lib.optionals withGUI [ gtk2 sqlite ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${src.rev}"
  ];

  buildFlags = [ "all" ] ++ lib.optional withGUI "gui";

  installTargets = [ "install" ] ++ lib.optional withGUI "install-gui";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ezix.org/project/wiki/HardwareLiSter";
    description = "Provide detailed information on the hardware configuration of the machine";
    license = licenses.gpl2;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}
