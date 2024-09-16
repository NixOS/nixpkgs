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

stdenv.mkDerivation (finalAttrs: {
  pname = "pmenu";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "pmenu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7NI5az3LxOYEnsts8Qqi3gvO3dXpNjPDOTW2c5Y25Lc=";
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

  meta = {
    description = "Pie-menu tool";
    homepage = "https://github.com/phillbush/pmenu";
    license = lib.licenses.mit;
    longDescription = ''
      πmenu is a pie menu utility for X. πmenu receives a menu specification in
      stdin, shows a menu for the user to select one of the options, and outputs
      the option selected to stdout.
    '';
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.unix;
    mainProgram = "pmenu";
  };
})
