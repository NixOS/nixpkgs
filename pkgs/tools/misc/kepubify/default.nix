{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "geek1011";
    repo = pname;
    rev = "v${version}";
    sha256 = "168n4xbhjrzwzlhvakmsd0nwqjwgibphkwzq5hcxrk9ywpqpxjad";
  };

  modSha256 = "18q9ywsjc2v1bsmw7307dpd4v5m7v80hbhijkfrkcyqzj34jrq43";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." "covergen" "seriesmeta" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
