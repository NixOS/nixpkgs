{ lib, buildGoModule, fetchFromGitHub, pkg-config, ffmpeg }:

buildGoModule rec {
  pname = "hydron";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "v${version}";
    sha256 = "BfMkKwz7ITEnAIMGUHlBH/Dn9yLjWKoqFWupPo1s2cs=";
  };

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "sha256-TxeHfO5IUVsKmKZ1e0/KXi+6dk2nn6AoNG0eB3jyGkY=";
  proxyVendor = true;

  buildInputs = [ ffmpeg ];

  meta = with lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
  };
}
