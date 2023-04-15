{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-eJD+7J5R+Oomj4QbOj5QHB30F0jpWmnkbl6bhVOEgDU=";
  };

  vendorHash = "sha256-UMRAyUcGxPsW4Q7o5KtXMmdcuY+DEGhbm4jPBVLOLGQ=";

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
    platforms = platforms.unix;
  };
}
