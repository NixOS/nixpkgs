{ buildGoModule, fetchgit, lib }:

buildGoModule rec {
  pname = "cue";
  version = "0.3.0";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "1h3809xgmn7dr57i3cnifr7r555i3zh3kfsv0gxa9nd7068w19xm";
  };

  vendorSha256 = "10kvss23a8a6q26a7h1bqc3i0nskm2halsvc9wdv9zf9qsz7zjkp";

  doCheck = false;

  subPackages = [ "cmd/cue" ];

  buildFlagsArray = [
    "-ldflags=-X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    maintainers = with lib.maintainers; [ solson ];
    license = lib.licenses.asl20;
  };
}
