{ pkgs, nodejs, nodejs-slim, stdenv, fetchFromGitHub, lib, ... }:
let
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = "1.10.0";
    sha256 = "WnonduUhhrxCMuXOgLk8voNnn+f6R5CsJ7VKpEmGwzk=";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = nodejs-slim;
  };
in
nodePackages.package.override {
  pname = "matrix-appservice-slack";

  inherit src;

  nativeBuildInputs = [ pkgs.makeWrapper nodejs ];

  dontStrip = false;

  postInstall = ''
    # replace nodejs with nodejs-slim in node_modules
    NODE=$(basename ${nodejs})
    NODE_SLIM=$(basename ${nodejs-slim})
    while read file; do
      substituteInPlace $file --replace "$NODE" "$NODE_SLIM"
    done < <(grep -l -R "$NODE" $out/lib )

    makeWrapper '${nodejs-slim}/bin/node' "$out/bin/matrix-appservice-slack" \
    --add-flags "$out/lib/node_modules/matrix-appservice-slack/lib/app.js"
  '';

  meta = with lib; {
    description = "A Matrix <--> Slack bridge";
    maintainers = with maintainers; [ beardhatcode ];
    license = licenses.asl20;
  };
}
