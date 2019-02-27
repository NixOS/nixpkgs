{ stdenv, fetchgit, git, nodejs, buildGoPackage, go-bindata }:

let
  src = fetchgit {
    url = "https://github.com/dgraph-io/ratel";
    rev = "3d5cd225ee8294f9c77e64d736003b612c79c3b4";
    sha256 = "098kbpzpfpkag16ng816y8p46n2p5y3655vhl61wn5c9mj7c68wm";
    leaveDotGit = true;
  };

  fetchNodeModules = stdenv.mkDerivation {
    name = "fetch-node-modules";
    inherit src;
    nativeBuildInputs = [ nodejs ];
    installPhase = ''
      export HOME=$(mktemp -d)
      cd client
      cp ${./package-lock.json} ./package-lock.json
      npm install
      cp -r node_modules $out
    '';
    # remove non-determenistic prefixes of build-time pathes
    postFixup = ''
      find $out -name package.json -exec sed -i -r 's,"/(tmp/nix-build|build/)[^/]+/([^"]+)","/build/\2",g' {} \;
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "06553nmmx03990fi92yisna2xwpx47kd7pr9ibhv090pm68db8dz";
  };
in buildGoPackage rec {
  name = "dgraph-ratel-${version}";
  version = "2019-02-22";
  inherit src;

  goPackagePath = "github.com/dgraph-io/ratel";
  nativeBuildInputs = [ nodejs git go-bindata ];

  preBuild = ''
    ( export HOME=$(mktemp -d)
      cd go/src/${goPackagePath}/client
      cp -r ${fetchNodeModules} node_modules
      npm --offline run build:prod
    )
    ( cd go/src/${goPackagePath}
      go-bindata -o ./server/bindata.go -pkg server -prefix "./client/build" -ignore=DS_Store ./client/build/...
    )
  '';

  meta = {
    homepage = https://github.com/dgraph-io/ratel;
    description = "Dgraph Dashboard";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.agpl3;
    platforms = [ "x86_64-linux" /* node-sass not available on "aarch64-linux" */ ];
  };
}
