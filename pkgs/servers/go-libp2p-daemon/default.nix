{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-libp2p-daemon";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "v${version}";
    hash = "sha256-3zlSD+9KnIOBlaE3gCTBGKwZY0rMW8lbb4b77BlJm/g=";
  };

  vendorHash = "sha256-8wrtPfuZ9X3cKjDeywht0d3p5lQouk6ZPO1PIjBz2Ro=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
