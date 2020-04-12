{ buildGoModule, fetchgit, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.1.1";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "1qbnm3qb8jz9bljw2gb5bb9g41s5lbq4xvcaj3zgi4fc3708hlji";
  };

  modSha256 = "0n9idgishlp4gaq12kngi42rq9rnkas7g6cj7jpkk8p30c74ki6z";

  subPackages = [ "cmd/cue" ];

  buildFlagsArray = [
    "-ldflags=-X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    maintainers = with stdenv.lib.maintainers; [ solson ];
    license = stdenv.lib.licenses.asl20;
  };
}
