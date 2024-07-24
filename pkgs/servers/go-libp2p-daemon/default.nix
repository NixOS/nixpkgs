{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-libp2p-daemon";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "v${version}";
    hash = "sha256-UIiP6Tb0ys1slB4YQ2m7KlrHIZDfUaKs4RAyuxWBhhw=";
  };

  vendorHash = "sha256-60+JcyVV0uW+T0JZ/keyeYJNWrR3BhLInIgwbpoAe/Q=";

  doCheck = false;

  meta = with lib; {
    description = "Libp2p-backed daemon wrapping the functionalities of go-libp2p for use in other languages";
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
