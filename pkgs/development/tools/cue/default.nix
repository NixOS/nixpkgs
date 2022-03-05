{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cue";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    sha256 = "sha256-6HD3wcBo21Dep4ckx+oDWAC4nuTvCzlp0bwQxZox2b4=";
  };

  vendorSha256 = "sha256-tY9iwQW6cB1FgLAmkDNMrvIxR+i4aGYhNs4tepI654o=";

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
