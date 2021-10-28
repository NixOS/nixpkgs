# How to generate a new version:
#
# Update version and hash as usual.
#
# ```
# cd fx_cast/app
# # Add `"name": "fx_cast_bridge", "version": "...",` to package.json and package-lock.json
# nix run nixpkgs.nodePackages.node2nix -c node2nix -l package-lock.json -d
# cp -v node-*.nix package*.json ~/p/nixpkgs/pkgs/tools/misc/fx_cast/app
# ```
{ pkgs, stdenv }: let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) nodejs stdenv lib python2 runCommand writeTextFile;
    inherit pkgs;
    libtool = if stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
  nodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
    inherit nodeEnv;
    globalBuildInputs = [pkgs.avahi-compat];
  };
in
stdenv.mkDerivation rec {
  name = "fx_cast_bridge-${version}";
  version = "0.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "hensm";
    repo = "fx_cast";
    rev = "v${version}";
    hash = "sha256:1prgk9669xgwkdl39clq0l75n0gnkkpn27gp9rbgl4bafrhvmg9a";
  };

  buildInputs = with pkgs; [
    nodejs
  ];

  buildPhase = ''
    ln -vs ${nodePackages.nodeDependencies}/lib/node_modules app/node_modules
    npm run build:app
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/mozilla/native-messaging-hosts $out/opt

    substituteInPlace dist/app/fx_cast_bridge.json \
      --replace "$(realpath dist/app/fx_cast_bridge.sh)" "$out/bin/fx_cast_bridge"
    mv dist/app/fx_cast_bridge.json $out/lib/mozilla/native-messaging-hosts

    echo "#! /bin/sh
      NODE_PATH=${nodePackages.nodeDependencies}/lib/node_modules exec ${pkgs.nodejs}/bin/node $out/opt/fx_cast_bridge/src/main.js --_name fx_cast_bridge \"\$@\"
    " >$out/bin/fx_cast_bridge
    chmod +x $out/bin/fx_cast_bridge

    mv dist/app $out/opt/fx_cast_bridge
  '';

  meta = with pkgs.lib; {
    description = "Implementation of the Chrome Sender API (Chromecast) within Firefox";
    homepage = "https://hensm.github.io/fx_cast/";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill kevincox ];
  };
}
