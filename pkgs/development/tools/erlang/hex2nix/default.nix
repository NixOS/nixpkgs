{ fetchFromGitHub, fetchRebar3Deps, rebar3Relx }:

rebar3Relx rec {
    name = "hex2nix";
    version = "0.0.6-42d7b2ec";

    releaseType = "escript";

    checkouts = fetchRebar3Deps {
      inherit name version;
      src = "${src}/rebar.config";
      sha256 = "0z6v1f6hagl3qyj97frqr2ww3adrwgfwdyb2zshaai0d3xchg3ly";
    };

    src = fetchFromGitHub {
      owner  = "erlang-nix";
      repo   = "hex2nix";
      rev    = "42d7b2ec64f61f21061066b192003cf7f460bf43";
      sha256 = "0ac1fmckvid5077djg3ajycxn7gwbf7pdk1knhfp8yva3c5qq58r";
    };
}
