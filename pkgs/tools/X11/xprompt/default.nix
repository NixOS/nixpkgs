{ lib
, stdenv
, fetchFromGitHub
, writeText
, fontconfig
, libX11
, libXft
, libXinerama
, conf ? null
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "xprompt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xprompt";
    rev = "v${version}";
    sha256 = "sha256-pOayKngUlrMY3bFsP4Fi+VsOLKCUQU3tdkZ+0OY1SCo=";
  };

  buildInputs = [
    fontconfig
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

  makeFlags = [ "CC:=$(CC)" "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A dmenu rip-off with contextual completion";
    longDescription = ''
      XPrompt is a prompt for X. XPrompt features a text input field where the
      user can type in a text subject to tab-completion.
    '';
    homepage = "https://github.com/phillbush/xprompt";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
