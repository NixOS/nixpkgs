{ lib, beamPackages, makeWrapper, rebar3, elixir, erlang, fetchFromGitHub }:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.9.2";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-khC3gtRvywgAY6qHslZgAV3kmziJgKhdCB8CDg/HkIU=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-rwWGs4fGeuyV6BBFgCyyDwKf/YLgs1wY0xnHYy8iioE=";
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
