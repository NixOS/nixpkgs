{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-hI6x3DOB7pP+umnEFqL0sIx+6qN74sooLdkR2pC74D8=";
  };

  vendorSha256 = "sha256-bsVzV2M31BA7X6aq8na7v56uGYgne4OwR5kz/utmQHI=";

  doCheck = false;

  subPackages = [ "cmd/task" ];

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task
  '';

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
