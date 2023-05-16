{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-shadowsocks2";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${version}";
    sha256 = "sha256-z2+5q8XlxMN7x86IOMJ0qbrW4Wrm1gp8GWew51yBRFg=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-RrHksWET5kicbdQ5HRDWhNxx4rTi2zaVeaPoLdg4uQw=";
=======
  vendorSha256 = "sha256-RrHksWET5kicbdQ5HRDWhNxx4rTi2zaVeaPoLdg4uQw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
