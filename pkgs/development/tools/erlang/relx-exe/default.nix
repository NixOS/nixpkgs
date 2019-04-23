{ stdenv, fetchHex, fetchRebar3Deps, rebar3Relx }:

rebar3Relx rec {
  name = "relx-exe";
  version = "3.23.1";
  releaseType = "escript";

  src = fetchHex {
    pkg = "relx";
    sha256 = "13j7wds2d7b8v3r9pwy3zhwhzywgwhn6l9gm3slqzyrs1jld0a9d";
    version = "3.23.1";
  };

  checkouts = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "046b1lb9rymndlvzmin3ppa3vkssjqspyfp98869k11s5avg76hd";
  };
}
