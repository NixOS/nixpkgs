{ lib, beamPackages, makeWrapper, rebar3, elixir, erlang, fetchFromGitHub, nixosTests }:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.14.2";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-iD9FzIjm0OAnApgmMqw0bDTQH/pSC8Z2l4+3Y4y+ieQ=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-knqjnySXwh7/vMkFNfDZzSjojWpWPNZyR/RIDb9hdgA=";
  };

  postInstall = ''
    wrapProgram $out/bin/livebook \
      --prefix PATH : ${lib.makeBinPath [ elixir erlang ]} \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
    '';

  passthru.tests = {
    livebook-service = nixosTests.livebook-service;
  };

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with maintainers; [ munksgaard scvalex ];
    platforms = platforms.unix;
  };
}
