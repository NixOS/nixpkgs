{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "1yf5s22q4hsxvgzrj4k6gbbq0whl5b9j12mbwimxaf53q535wy4q";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/task" ];

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/task $out/bin/go-task
  '';

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ parasrah ];
  };
}
