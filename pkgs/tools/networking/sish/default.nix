{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TiS28bqwcTbKKAj1trTOEs2a4FGADrkutIU3DkaTcjE=";
  };

  vendorSha256 = "sha256-Cky4ggZoNbIZK7w4tL00XqqyDDe0fmYk/+xZvtG/Nmg=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
