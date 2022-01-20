{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.9.24";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4M7Oj/hHFH2OUz0y64GIEnv0Kk0+zAje3kHA2e4RQS0=";
  };

  vendorSha256 = "sha256-oYZZ9DzpY544QTWDGz/wkHA9aP0riEXLUTWvzV1KxQc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}
