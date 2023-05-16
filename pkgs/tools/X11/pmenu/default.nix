{ lib
, stdenv
, fetchFromGitHub
, writeText
, fontconfig
, imlib2
, libX11
, libXext
, libXft
, libXinerama
, libXrender
, conf ? null
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "pmenu";
  version = "3.1.1";
=======
stdenv.mkDerivation rec {
  pname = "pmenu";
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "pmenu";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-7NI5az3LxOYEnsts8Qqi3gvO3dXpNjPDOTW2c5Y25Lc=";
=======
    rev = "v${version}";
    sha256 = "sha256-xeOiJEOPz5QEMlWP6bWhTjmj4tfNqh3rsEVmnKvrKuM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    fontconfig
    imlib2
    libX11
    libXext
    libXft
    libXinerama
    libXrender
  ];

  postPatch = let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "mv ${configFile} config.h";

  makeFlags = [
    "INSTALL=install"
    "PREFIX=\${out}"
  ];

<<<<<<< HEAD
  meta = {
    description = "A pie-menu tool";
    homepage = "https://github.com/phillbush/pmenu";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "A pie-menu tool";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      πmenu is a pie menu utility for X. πmenu receives a menu specification in
      stdin, shows a menu for the user to select one of the options, and outputs
      the option selected to stdout.
    '';
<<<<<<< HEAD
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.unix;
  };
})
=======
    homepage = "https://github.com/phillbush/pmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
