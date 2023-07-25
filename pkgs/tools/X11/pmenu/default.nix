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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "pmenu";
    rev = "v${version}";
    sha256 = "sha256-bX1qiNUTxNFeS0hNc5dUqQLEgv22nHqJ0yW55CQlGw4=";
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
