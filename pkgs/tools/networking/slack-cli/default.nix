# slack-cli must be configured using the SLACK_CLI_TOKEN environment
# variable. Using `slack init` will not work because it tries to write
# to the Nix store.

{ stdenv, lib, fetchurl, makeWrapper, curl, jq }:

stdenv.mkDerivation rec {
  name = "slack-cli";
  version = "0.18.0";

  src = fetchurl {
    url = "https://github.com/rockymadden/slack-cli/archive/v${version}.tar.gz";
    sha256 = "0q19l88c1mvnzya58q21pc3v6mff56z43288kzk50000ri286wq2";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp src/slack $out/bin
    wrapProgram $out/bin/slack --prefix PATH : ${lib.makeBinPath [ curl jq ]}
  '';
}
