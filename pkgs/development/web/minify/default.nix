{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qna2u+Y4eRGLNvRKDbL/VQud1pn8b1wWzbKQM1p0Yws=";
  };

  vendorSha256 = "sha256-stj3fOaPM70kF6vTX/DEs4qFq/O0Vq0TFw0J/3L5NmA=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
  };
}
