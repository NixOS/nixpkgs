{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "ws";
  version = "0.2.1";

  goPackagePath = "github.com/hashrocket/ws";

  src = fetchFromGitHub {
    owner = "hashrocket";
    repo = "ws";
    rev = "e9404cb37e339333088b36f6a7909ff3be76931d";
    sha256 = "sha256-q6c761Evz7Q6nH1fHgEn2uCFokoN0OzqhyxIFn6mWqQ=";
  };

  meta = with lib; {
    description = "websocket command line tool";
    homepage    = "https://github.com/hashrocket/ws";
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
