{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-shadowsocks2";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${version}";
    sha256 = "sha256-ouJGrVribymak4SWaLbGhlp41iuw07VdxCypoBr1hWA=";
  };

  vendorSha256 = "sha256-RrHksWET5kicbdQ5HRDWhNxx4rTi2zaVeaPoLdg4uQw=";

  meta = with lib; {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
