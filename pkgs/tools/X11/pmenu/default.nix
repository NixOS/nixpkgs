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

stdenv.mkDerivation rec {
  pname = "pmenu";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "pmenu";
    rev = "v${version}";
    sha256 = "sha256-xeOiJEOPz5QEMlWP6bWhTjmj4tfNqh3rsEVmnKvrKuM=";
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

  meta = with lib; {
    description = "A pie-menu tool";
    longDescription = ''
      πmenu is a pie menu utility for X. πmenu receives a menu specification in
      stdin, shows a menu for the user to select one of the options, and outputs
      the option selected to stdout.
    '';
    homepage = "https://github.com/phillbush/pmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
