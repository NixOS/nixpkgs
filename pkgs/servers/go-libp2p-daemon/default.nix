{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-libp2p-daemon";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "v${version}";
    hash = "sha256-1ZmtUrk5BO5tl5Brcyz6NCD9vdf5XXtbmophXVX05Tk=";
  };

  vendorHash = "sha256-jT3t7m8wPKejbjCvQzx+PIAl9NYk0rAl6edywvR1FaE=";

  doCheck = false;

  meta = with lib; {
    description = "Libp2p-backed daemon wrapping the functionalities of go-libp2p for use in other languages";
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
