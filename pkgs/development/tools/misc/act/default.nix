{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "14ird8z8f467spa0kdzjf6lq7pipq7rwxrdk6ppv7y1fxw96qm9x";
  };

  vendorSha256 = "0ns20vvrj0j921wsx227dxbpga6kll7pxglfqhl53xckrh85yyd8";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}