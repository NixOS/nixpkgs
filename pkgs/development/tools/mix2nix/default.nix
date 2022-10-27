{ stdenv, lib, fetchFromGitHub, elixir, erlang }:

stdenv.mkDerivation rec {
  pname = "mix2nix";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = version;
    sha256 = "0flsw8r4x27qxyrlazzjmjq3zkkppgw9krcdcqj7wbq06r2dck3q";
  };

  nativeBuildInputs = [ elixir ];
  buildInputs = [ erlang ];

  buildPhase = "mix escript.build";
  installPhase = "install -Dt $out/bin mix2nix";

  meta = with lib; {
    description = "Generate nix expressions from mix.lock file.";
    license = licenses.mit;
    maintainers = with maintainers; [ ydlr ] ++ teams.beam.members;
  };
}
