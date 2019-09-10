{ buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "cuelang";
    repo = "cue";
    rev = "v${version}";
    sha256 = "1nnwfvw8pkzqqzkw3g32szpwwnwnyyghd3wk3qq3gzbj43ac38bp";
  };

  modSha256 = "18fd2sa8xgskky0nrjf3qndv8crrwbp9nq9f4i68bdc82p8a7gfs";

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
