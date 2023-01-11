{ lib, stdenv, fetchFromGitHub, apacheHttpd, python3, libintl }:

stdenv.mkDerivation rec {
  pname = "mod_python";
  version = "unstable-2022-10-18";

  src = fetchFromGitHub {
    owner = "grisha";
    repo = pname;
    rev = "d066b07564d2194839eceb535485eb1ba0c292d8";
    hash = "sha256-EH8wrXqUAOFWyPKfysGeiIezgrVc789RYO4AHeSA6t4=";
  };

  patches = [ ./install.patch ];

  installFlags = [
    "LIBEXECDIR=$(out)/modules"
    "BINDIR=$(out)/bin"
  ];

  passthru = { inherit apacheHttpd; };

  buildInputs = [ apacheHttpd python3 ]
    ++ lib.optional stdenv.isDarwin libintl;

  meta = with lib; {
    homepage = "http://modpython.org/";
    description = "An Apache module that embeds the Python interpreter within the server";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
