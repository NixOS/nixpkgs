{ buildGoModule, fetchgit, lib }:

buildGoModule rec {
  pname = "cue";
  version = "0.3.2";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "0rfgpq4dyd3zm07vcjzn5vv0dhvvryrarxc50sd2pxagbq5cqc8l";
  };

  vendorSha256 = "10kvss23a8a6q26a7h1bqc3i0nskm2halsvc9wdv9zf9qsz7zjkp";

  doCheck = false;

  subPackages = [ "cmd/cue" ];

  buildFlagsArray = [
    "-ldflags=-s -w -X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    maintainers = with lib.maintainers; [ solson ];
    license = lib.licenses.asl20;
  };
}
