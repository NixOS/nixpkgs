{ buildGoModule, fetchgit, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.0.3";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "1abvvgicr64ssiprkircih2nrbcr1yqxf1qkl21kh0ww1xfp0rw7";
  };

  modSha256 = "0r5vbplcfq1rsp2jnixq6lfbpcv7grf0q38na76qy7pjb57zikb6";

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
