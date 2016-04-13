{stdenv, fetchFromGitHub, erlang }:

stdenv.mkDerivation rec {
    name = "rebar3-nix-bootstrap";
    version = "0.0.3";

    src = fetchFromGitHub {
        owner = "erlang-nix";
        repo = "rebar3-nix-bootstrap";
        rev = "${version}";
        sha256 = "01yyaz104jj3mxx8k10q3rwpn2rh13q1ja5r0iq37qyjmg8xflhq";
    };

    buildInputs = [ erlang ];

    installFlags = "PREFIX=$(out)";

    meta = {
      description = "Shim command to help bootstrap a rebar3 project on Nix";
      license = stdenv.lib.licenses.asl20;
      homepage = "https://github.com/erlang-nix/rebar3-nix-bootstrap";
      maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    };
}
