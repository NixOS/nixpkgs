{ lib, beamPackages, makeWrapper, rebar3, elixir, erlang, fetchFromGitHub }:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.10.0";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-Bp1CEvVv5DPDDikRPubsG6p4LLiHXTEXE+ZIip3LsGA=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-qFLCWr7LzI9WNgj0AJO3Tw7rrA1JhBOEpX79RMjv2nk=";
  };

  installPhase = ''
    mix escript.build
    mkdir -p $out/bin
    mv ./livebook $out/bin

    wrapProgram $out/bin/livebook \
      --prefix PATH : ${lib.makeBinPath [ elixir ]} \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
  '';

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with maintainers; [ munksgaard ];
    platforms = platforms.unix;
  };
}
