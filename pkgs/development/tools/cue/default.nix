{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cue";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    sha256 = "1q1mkqb6fk515g556yn8ks3gqrimfbadprmbv5rill1lpipq5xbj";
  };

  vendorSha256 = "12p77a97lbff6qhncs5qx13k3wmf9hrr09mhh12isw5s0p0n53xm";

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
