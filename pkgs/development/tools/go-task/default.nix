{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-3DTjxcMxgaTMunctHaCgOX5/P85lJDRin6RpMuv9Rfg=";
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
