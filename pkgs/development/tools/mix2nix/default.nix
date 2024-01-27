{ stdenv, lib, fetchFromGitHub, elixir, erlang }:

stdenv.mkDerivation rec {
  pname = "mix2nix";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = version;
    hash = "sha256-iWy5q6ERzg8hRZs+bFtR6drZ9yI8Qh1v+47q3q2fFTM=";
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
