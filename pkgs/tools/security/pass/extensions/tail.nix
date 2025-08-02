{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "1.2.0";
in
stdenv.mkDerivation {
  pname = "pass-tail";
  inherit version;

  src = fetchFromGitHub {
    owner = "palortoff";
    repo = "pass-extension-tail";
    tag = "v${version}";
    hash = "sha256-RyPXW4Lgx6GdF9j+zEJqKRGxinDwPCmF9WXJ5yW4Pcc=";
  };

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    description = "A pass extension to avoid printing the password to the console";
    homepage = "https://github.com/palortoff/pass-extension-tail";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _3442 ];
    platforms = lib.platforms.unix;
  };
}
