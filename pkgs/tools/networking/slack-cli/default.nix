# slack-cli must be configured using the SLACK_CLI_TOKEN environment
# variable. Using `slack init` will not work because it tries to write
# to the Nix store.

{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, jq }:

stdenv.mkDerivation rec {
  name = "slack-cli";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "rockymadden";
    repo = "slack-cli";
    rev = "v${version}";
    sha256 = "022yr3cpfg0v7cxi62zzk08vp0l3w851qpfh6amyfgjiynnfyddl";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp src/slack $out/bin
    wrapProgram $out/bin/slack --prefix PATH : ${lib.makeBinPath [ curl jq ]}
  '';
}
