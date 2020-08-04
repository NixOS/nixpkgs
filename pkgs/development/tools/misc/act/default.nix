{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xmrb8wbxkb52l2c7fxxy5wa9lsl591fl65zicv0nrbil36q4wfd";
  };

  vendorSha256 = "0qf26g0a2j1mbzlc7xjackww22w9bl1x0iw3q1x6kq7fp8xiwhdn";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
