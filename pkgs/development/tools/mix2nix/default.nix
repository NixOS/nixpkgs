{ stdenv, lib, fetchFromGitHub, elixir, erlang }:

stdenv.mkDerivation {
  pname = "mix2nix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = "b153a252f0689d3f6919e16c2df2fb3b6bcc9d2a";
    sha256 = "15wyz7gdjywsqvsf1ad9gklvqsqi7lwgmyks3bjlc2sk6kpdxdmi";
  };

  buildInputs = [ elixir erlang ];

  buildPhase = "mix escript.build";
  installPhase = "install -Dt $out/bin mix2nix";

  meta = with lib; {
    description = "Generate nix expressions from mix.lock file.";
    license = licenses.mit;
    maintainers = with maintainers; [ ydlr beam ];
  };
}
