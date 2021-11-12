{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-BOOtzI45Vbce2XmcleyDOg/+6YDASCIOBvBytZDK7ZA=";
  };

  vendorSha256 = "sha256-N23jdHR+Alo3dYkfZ4ygr5UU2NEO/cgrgN52glU2hd8=";

  doCheck = false;

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
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
