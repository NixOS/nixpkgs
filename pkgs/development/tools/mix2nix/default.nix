{ stdenv, lib, fetchFromGitHub, elixir, erlang }:

stdenv.mkDerivation rec {
  pname = "mix2nix";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = version;
    sha256 = "11qn80im5zfbx25ibxqrgi90mglf8pnsmrqsami633mcf2gvj2hy";
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
