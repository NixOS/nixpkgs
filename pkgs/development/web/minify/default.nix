{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "12jns7m9liyjg9wy8ynvji2d2g4k2z1ymp6k3610mivmvg159sy4";
  };

  vendorSha256 = "120d3nzk8cr5496cxp5p6ydlzw9mmpg7dllqhv1kpgwlbxmd8vr3";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}