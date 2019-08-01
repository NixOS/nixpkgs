{ fetchHex, fetchRebar3Deps, rebar3Relx }:

rebar3Relx rec {
  name = "relx-exe";
  version = "3.32.1";
  releaseType = "escript";

  src = fetchHex {
    pkg = "relx";
    sha256 = "0693k8ac7hvpm9jd3ysbdn8bk97d68ini22p1fsqdsi9qv9f7nq7";
    inherit version;
  };

  checkouts = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "0l7r3x7zwcz49013zv8z5v2i06p7wqkgzdyzrl8jk0hglscvhpf6";
  };
}
