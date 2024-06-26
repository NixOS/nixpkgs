{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-tail";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "palortoff";
    repo = "pass-extension-tail";
    rev = "v${version}";
    sha256 = "RyPXW4Lgx6GdF9j+zEJqKRGxinDwPCmF9WXJ5yW4Pcc=";
  };

  buildInputs = [ ];

  dontBuild = true;

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "A pass extension to avoid printing the password to the console";
    homepage = "https://github.com/palortoff/pass-extension-tail";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pablito2020 ];
    platforms = platforms.unix;
  };
}
