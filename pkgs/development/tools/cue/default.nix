{ buildGoModule, fetchgit, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.0.11";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "146h3nxx72n3byxr854lnxj7m33ipbmg6j9dy6dlwvqpa7rndrmp";
  };

  modSha256 = "1q0fjm34mbijjxg089v5330vc820nrvwdkhm02zi45rk2fpdgdqd";

  subPackages = [ "cmd/cue" ];

  buildFlagsArray = [
    "-ldflags=-X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data.";
    homepage = https://cue.googlesource.com/cue;
    maintainers = with stdenv.lib.maintainers; [ solson ];
    license = stdenv.lib.licenses.asl20;
  };
}
