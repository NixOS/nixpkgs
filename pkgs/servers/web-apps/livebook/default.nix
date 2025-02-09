{ lib, beamPackages, makeWrapper, rebar3, elixir, erlang, fetchFromGitHub, nixosTests }:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.12.0";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-ONNl88ZUjeAjYV8kdk4Tf6noQ7YSp/UN9OHEJHk7+5s=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-JA0890hGShavn60khnevt4L0qEWKZnTmafImU4dkCr8=";
  };

  installPhase = ''
    mix escript.build
    mkdir -p $out/bin
    mv ./livebook $out/bin

    wrapProgram $out/bin/livebook \
      --prefix PATH : ${lib.makeBinPath [ elixir ]} \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
  '';

  passthru.tests = {
    livebook-service = nixosTests.livebook-service;
  };

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with maintainers; [ munksgaard ];
    platforms = platforms.unix;
  };
}
