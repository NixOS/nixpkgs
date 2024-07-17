{
  stdenv,
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  makeWrapper,
  ruby,
}:

let
  rubyEnv = bundlerEnv {
    name = "shopify-cli";
    gemdir = ./.;
    ruby = ruby;
  };
in
stdenv.mkDerivation rec {
  pname = "shopify-cli";
  version = (import ./gemset.nix).shopify-cli.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/shopify $out/bin/shopify
    wrapProgram $out/bin/shopify \
      --prefix PATH : ${lib.makeBinPath [ ruby ]}
  '';

  passthru.updateScript = bundlerUpdateScript "shopify-cli";

  meta = with lib; {
    description = "CLI which helps you build against the Shopify platform faster";
    homepage = "https://github.com/Shopify/shopify-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    mainProgram = "shopify";
    platforms = ruby.meta.platforms;
  };
}
