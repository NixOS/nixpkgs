{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-eco";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "coloradocolby";
    repo = "gh-eco";
    rev = "v${version}";
    sha256 = "sha256-rJG1k8lOyXQSP3FgyyHZvVrQkn2yEtAcgg9CpbPvCwY=";
  };

  vendorSha256 = "sha256-Qx/QGIurjKGFcIdCot1MFPatbGHfum48JOoHlvqA64c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = licenses.mit;
    maintainers = with maintainers; [ helium ];
  };
}

