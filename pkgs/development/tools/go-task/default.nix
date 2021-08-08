{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-EksCnhSde25hradmKaDSOfIa/QnMAlIbgbQWX6k5v+4=";
  };

  vendorSha256 = "sha256-Y2Yuc2pcxW0M1CJfN3dezPB9cg6MvOUg5A+yFHCwntk=";

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
