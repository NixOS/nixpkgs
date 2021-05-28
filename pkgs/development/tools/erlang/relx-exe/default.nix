{ fetchHex, fetchRebar3Deps, rebar3Relx }:

rebar3Relx rec {
  name = "relx-exe";
  version = "4.3.0";
  releaseType = "escript";

  src = fetchHex {
    pkg = "relx";
    sha256 = "sha256-c44JSab8fQ3p5FSdwPc9m24FtTnhURuySFkHArMiBEA=";
    inherit version;
  };

  checkouts = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "sha256-BY/c4+vqdnn4FBPzLExEZIZ27f1g46XISb8mIpMU8aI=";
  };
}
