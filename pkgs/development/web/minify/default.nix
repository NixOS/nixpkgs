{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "06xzb681g4lfrpqa1rhpq5mm83vpik8qp6gjxqm2n21bfph88jm2";
  };

  vendorSha256 = "120d3nzk8cr5496cxp5p6ydlzw9mmpg7dllqhv1kpgwlbxmd8vr3";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}
