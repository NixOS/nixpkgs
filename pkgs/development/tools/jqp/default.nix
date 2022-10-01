{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dVarasXLJrB/akMUvjZn313+bqM39Ji4l91PAxwmfG0=";
  };

  vendorSha256 = "sha256-KlnKWeLbmLH6M5+oD/BYuqkTyrV9Xo7ibrNjukFe7ss=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A TUI playground to experiment with jq";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
