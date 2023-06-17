{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "starcharts";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "starcharts";
    rev = "v${version}";
    hash = "sha256-XlR3AZgxp3ZljDR4H/BANeCqfR/G0a1KXo789GqNN8Y=";
  };

  vendorHash = "sha256-ki+LaJ3dgN/cPA5zpbV/LiWIjuTKqojjpdRZ8VCZ0Kk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Plot your repository stars over time";
    homepage = "https://github.com/caarlos0/starcharts";
    changelog = "https://github.com/caarlos0/starcharts/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
