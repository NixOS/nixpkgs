{ fetchFromGitHub, fetchRebar3Deps, rebar3Relx }:

rebar3Relx rec {
    name = "hex2nix";
    version = "0.0.6-a31eadd7";

    releaseType = "escript";

    checkouts = fetchRebar3Deps {
      inherit name version;
      src = "${src}/rebar.config";
      sha256 = "1b59vk6ynakdiwqd1s6axaj9bvkaaq7ll28b48nv613z892h7nm5";
    };

    src = fetchFromGitHub {
      owner  = "erlang-nix";
      repo   = "hex2nix";
      rev    = "a31eadd7af2cbdac1b87991b378e98ea4fb40ae0";
      sha256 = "1hnkrksyrbpq2gq25rfsrnm86n0g3biab88gswm3zj88ddrz6dyk";
    };
}
