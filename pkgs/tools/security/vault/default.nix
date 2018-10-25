{ pkgs, stdenv, fetchzip, nodejs-8_x, fetchFromGitHub, go, gox, go-bindata, go-bindata-assetfs,  nodejs, python, nodePackages, yarn2nix, removeReferencesTo }:
let
  nodejs = nodejs-8_x;
  # Deprecated since vault 0.8.2: use `vault -autocomplete-install` instead
  # to install auto-complete for bash, zsh and fish
  vaultBashCompletions = fetchFromGitHub {
    owner = "iljaweis";
    repo = "vault-bash-completion";
    rev = "e2f59b64be1fa5430fa05c91b6274284de4ea77c";
    sha256 = "10m75rp3hy71wlmnd88grmpjhqy0pwb9m8wm19l0f463xla54frd";
  };
in stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "0lckpfp1yw6rfq2cardsp2qjiajg706qjk98cycrlsa5nr2csafa";
  };


  ui = yarn2nix.mkYarnPackage {
    src = "${src}/ui";
    yarnNix = ./yarn.nix;
    extraBuildInputs = [ nodePackages.node-gyp-build ];
    yarnPreBuild = ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    '';
    pkgConfig.node-sass = {
      buildInputs = [ python ];
      postInstall = ''
        npm run build
      '';
    };
    buildPhase = ''
      export HOME=$PWD/yarn_home
      yarn run build --output-path $out/ember;
    '';
  };

  nativeBuildInputs = [ go gox go-bindata go-bindata-assetfs removeReferencesTo ];

  preBuild = ''
    patchShebangs ./
    substituteInPlace scripts/build.sh --replace 'git rev-parse HEAD' 'echo ${src.rev}'
    sed -i /^'rm -rf pkg'/d scripts/build.sh
    sed -i s/'^GIT_DIRTY=.*'/'GIT_DIRTY="+NixOS"'/ scripts/build.sh

    mkdir -p .git/hooks src/github.com/hashicorp
    mkdir -p pkg/web_ui
    cp -r ${ui}/ember/* pkg/web_ui
    chmod -R u+w pkg/web_ui 
    go-bindata-assetfs -pkg http -prefix pkg -modtime 1480000000 -tags ui ./pkg/web_ui/...
    mv bindata_assetfs.go http

    rm -rf pkg/web_ui


    ln -s $(pwd) src/github.com/hashicorp/vault

    export GOPATH=$(pwd)
  '';

  makeFlags = [ "dev-ui" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions

    cp pkg/*/vault $out/bin/
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' +

    cp ${vaultBashCompletions}/vault-bash-completion.sh $out/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri arianvp ];
  };
}
