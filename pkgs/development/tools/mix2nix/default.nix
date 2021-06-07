{ stdenv, lib, fetchFromGitHub, elixir, erlang }:

stdenv.mkDerivation rec {
  pname = "mix2nix";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = version;
    sha256 = "0q4yq8glrdj72j7b9xnwb6j3cli3cccimh9sb7acb4npaiivvf69";
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
