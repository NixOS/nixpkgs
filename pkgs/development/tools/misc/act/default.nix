{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s7bgm2q7z9xpaj6kfvg63v12k35ckaxwmh6bbjh15xibaw58183";
  };

  vendorSha256 = "0bcrw3hf92m7n58lrlm0vj1wiwwy82q2rl1a725q3d6xwvi5kh9h";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
