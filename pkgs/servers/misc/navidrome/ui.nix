{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  pname = "navidrome-ui";
  version = import ./version.nix;

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;
  yarnLock = ./yarn.lock;

  src_all = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    sha256 = import ./source-sha.nix;
  };

  src = "${src_all}/ui";

  buildPhase = ''
    export HOME=$(mktemp -d)
    export WRITABLE_NODE_MODULES="$(pwd)/tmp"
    mkdir -p "$WRITABLE_NODE_MODULES"

    # react-scripts requires a writable node_modules/.cache, so we have to copy the symlink's contents back
    # into `node_modules/`.
    # See https://github.com/facebook/create-react-app/issues/11263
    cd deps/navidrome-ui
    node_modules="$(readlink node_modules)"
    rm node_modules
    mkdir -p "$WRITABLE_NODE_MODULES"/.cache

    # In `node_modules/.bin` are relative symlinks that would be broken after copying them over,
    # so we take care of them here.
    mkdir -p "$WRITABLE_NODE_MODULES"/.bin
    for x in "$node_modules"/.bin/*; do
      ln -sfv "$node_modules"/.bin/"$(readlink "$x")" "$WRITABLE_NODE_MODULES"/.bin/"$(basename "$x")"
    done

    ln -sfv "$WRITABLE_NODE_MODULES" node_modules
    cd ../..

    yarn build

    cd deps/navidrome-ui
    rm -rf node_modules
    ln -sf $node_modules node_modules
    cd ../..
  '';

}
