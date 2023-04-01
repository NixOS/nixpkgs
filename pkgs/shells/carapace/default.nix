{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-5T2bw07bkhEmlJa8Qw+USreY3MtGRHIUVrHLJOMk824=";
  };

  vendorHash = "sha256-s8U0ERAb/qLwen8ABfeZ21HLTgHWvHaYHazztSeP87c=";

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
