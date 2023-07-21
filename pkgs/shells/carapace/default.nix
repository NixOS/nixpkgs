{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-EWdo+86mZt5sQMPgX2Co484YaP6An7o7t9rmn3GujaI=";
  };

  vendorHash = "sha256-R+PfIG3d0eB0eTpAnZfSnvACtDOv0uxIzoW+f7rF4cY=";

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
