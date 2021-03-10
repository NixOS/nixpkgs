{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "0x94z023rsl7h9prw0i4zkwb5xf2frjz8f15mmcknw48r9ymw598";
  };

  vendorSha256 = "05sh4jbva23ggg2viknl49bwgkhf8dfvsv3rqkl4wwi9ag64qgha";

  doCheck = false;

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
    maintainers = with maintainers; [ parasrah ];
  };
}
