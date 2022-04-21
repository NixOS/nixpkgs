{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cue";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    sha256 = "sha256-v9MYrijnbtJpTgRZ4hmkaekisOyujldGewCRNbkVzWw=";
  };

  vendorSha256 = "sha256-jTfV8DJlr5LxS3HjOEBkVzBvZKiySrmINumXSUIq2mI=";

  checkPhase = "go test ./...";

  subPackages = [ "cmd/cue" ];

  ldflags = [
    "-s" "-w" "-X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/cue eval - <<<'a: "all good"' > /dev/null
  '';

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    maintainers = [];
    license = lib.licenses.asl20;
  };
}
