{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "00clafq3izvfwxkb85hf6s40yfw2hpsfz3xg4da28pgh1wlqb9ps";
  };

  modSha256 = "0ghp61m8fxg1iwq2ypmp99cqv3n16c06v2xzg9v34299vmd89gi2";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
