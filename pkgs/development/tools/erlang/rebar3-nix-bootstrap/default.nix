{stdenv, fetchFromGitHub, erlang }:

stdenv.mkDerivation rec {
    name = "rebar3-nix-bootstrap";
    version = "0.0.1";

    src = fetchFromGitHub {
        owner = "erlang-nix";
        repo = "rebar3-nix-bootstrap";
        rev = "${version}";
        sha256 = "0xyj7j59dmxyl5nhhsmb0r1pihmk0s4k02ga1rfgm30rij6n7431";
    };

    buildInputs = [ erlang ];

    installFlags = "PREFIX=$(out)";

    meta = {
      description = "Shim command to help bootstrap a rebar3 project on Nix";
      license = stdenv.lib.licenses.asl20;
      homepage = "https://github.com/erl-nix/rebar3-nix-bootstrap";
      maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    };
}
