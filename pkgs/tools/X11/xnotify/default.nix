{ lib
, stdenv
, fetchFromGitHub
, writeText
, fontconfig
, imlib2
, libX11
, libXft
, libXinerama
, conf ? null
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "xnotify";
  version = "unstable-2022-02-18";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xnotify";
    rev = "58c7d5763c3fb1c32a76560c85d20a25f59d4687";
    sha256 = "sha256-BSZesuBGAWYp3IMiiZi6CAyZEiz3sBJLQe6/JnxviLs=";
  };

  buildInputs = [
    fontconfig
    imlib2
    libX11
    libXft
    libXinerama
  ];

  postPatch = with lib;
    let
      configFile =
        if isDerivation conf || builtins.isPath conf
        then conf else writeText "config.h" conf;
    in
    optionalString (conf != null) "cp ${configFile} config.h";

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A tool to read notifications from stdin and pop them up on the screen";
    longDescription = ''
      XNotify displays a notification on the screen. XNotify receives a
      notification specification in stdin and shows a notification for the user
      on the screen.
    '';
    homepage = "https://github.com/phillbush/xnotify";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
