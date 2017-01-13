{ stdenv ? (import <nixpkgs> {}).stdenv
, lib ? (import <nixpkgs> {}).pkgs.lib
, pkgs ? (import <nixpkgs> {}).pkgs
, nodePackages ? (import <nixpkgs> {}).pkgs.nodePackages
}:
let
inherit nodePackages;
inherit lib;
inherit pkgs;

nan = nodePackages.buildNodePackage {
    name = "nan-2.0.5";
    src = pkgs.fetchFromGitHub {
      owner = "nodejs";
      repo = "nan";
      rev = "v2.0.5";
      sha256 = "0k32gcrf61i25a34pfhspmm5ih0xp75ni3bhvk774jxvwlg431b2";
    };
  };

ptyJS = nodePackages.buildNodePackage {
    name = "pty.js-0.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "chjj";
      repo = "pty.js";
      rev = "v0.3.0";
      sha256 = "06z33na0gqxffsj7wgfnp5k6smb5bwap02w6kn6gqa6d2hfkj81c";
    };

    buildInputs = nodePackages.nativeDeps."pty.js" or [];
    deps = [ nodePackages.by-spec."extend"."~1.2.1" nan ];
    peerDependencies = [];
  };
c9install = pkgs.fetchFromGitHub {
  owner = "c9";
  repo = "install";
  rev = "0b06c9fd98e4f48755f1a6a11ba4fab50b72b038";
  sha256 = "1y1b6x6k4n06facqjycds5riziz4dl3zb2kc4ddi3hqhc8mlr49m";
};

in stdenv.mkDerivation rec {
  name = "cloud9-${version}";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "c9";
    repo = "core";
    rev = "40854a89b738dd5691fba2dc6dde22ae656d694b";
    sha256 = "0xb2dnjgc7rqm2ygnbij6izaq83hlyjqg0jqigkp9gc50whacjl9";
  };
  configurePhase = ''
    mkdir -p $out
    mkdir -p $out/bin
    cp $src/* $out -R
    cd $out
    export HOME=$PWD
    substituteInPlace ./scripts/install-sdk.sh \
      --replace "\"\$NPM\" install" "\"\$NPM\" install --prefix=$out" \
      --replace 'updateCore || true' '# removed' \
      --replace 'installGlobalDeps\n' '# removed' \
      --replace "$DOWNLOAD $URL/master/install.sh | bash" "./install.sh" \
      --replace 'export C9_DIR="$HOME"/.c9' 'export C9_DIR=$out' \
      --replace '`which npm`' 'false'
    cp ${c9install}/install.sh $out/install.sh
    substituteInPlace ./install.sh \
      --replace "\"\$NPM\" install" "\"\$NPM\" install --prefix=$out" \
      --replace 'C9_DIR=$HOME/.c9' 'C9_DIR=$out;'
    mkdir -p $out/c9
    git init
    git config remote.origin.url https://github.com/c9/core
    git add --all
    git commit -m "Inital commit"
      '';
  buildPhase =''
    cd $out
    ls -al
    echo $PATH
    chmod +w plugins
    chmod +w node_modules
    ln -s ${nodePackages.extend}/lib/node_modules/extend/ node_modules/extend
    ln -s ${ptyJS}/lib/node_modules/pty.js/ node_modules/pty.js
    ln -s node_modules/pty.js/build/Release/pty.node $out/bin/pty.node
    ln -s ${nan}/lib/node_modules/nan/ node_modules/nan[
    # npm install -g --prefix=$out 
    # npm install --prefix=$out https://github.com/c9/nak/tarball/c9
    ./scripts/install-sdk.sh # totally impure!, 64 packages to add
    '';
  propogatedBuildInputs = with nodePackages; [ 
        extend ptyJS nan optimist async pkgs.nodejs pkgs.tmux pkgs.wget pkgs.git pkgs.python
      ];
  buildInputs = with nodePackages; [ 
        extend ptyJS nan optimist async pkgs.nodejs pkgs.tmux pkgs.wget pkgs.git pkgs.python
      ];
}
