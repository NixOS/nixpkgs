{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-N1rPAK+fjFqojxMMRgohTwhlYxHC0fUICZ+fcG23gUE=";
  };

  vendorHash = "sha256-LooEhKK+JSUaEMio81WGMv5l1SqEIs2r978yEc7sPlo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ star-szr ];
    license = licenses.mit;
  };
}
