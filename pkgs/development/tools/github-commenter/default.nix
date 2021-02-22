{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    sha256 = "HgiCgyig+49g275G6zZ0kGTxt1TSfFK8kt+SOf4ei74=";
  };

  vendorSha256 = "Gw+cR5sA5MGuclcvur8olmRtK04LDP5vKJ5k7yZO3B0=";

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.unix;
  };
}
