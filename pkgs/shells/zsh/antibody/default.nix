{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "1cxg0173d3xnpyzbisj926vh3qql9rw3q4j1z900m34gw7cvsdpf";
  };

  modSha256 = "08k4mzqcva7yq1zmfxhlqnd8kk70zry6cfghxl1bgmhnfjqh61qr";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 worldofpeace ];
  };
}
