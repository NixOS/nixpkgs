{ buildGoModule, fetchgit, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.0.15";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "0mipzci2zjp6yh4lxg9jrdxn03ska188zg3jl6g1zr8rn0ry274h";
  };

  modSha256 = "04dapx75zwi8cv1pj3c6266znrhwihv3df4izm3gjk34r2i07q6s";

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
