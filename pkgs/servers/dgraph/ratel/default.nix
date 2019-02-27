{ stdenv, fetchgit, glibcLocales, git, nodejs, buildGoPackage, go-bindata }:

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

    # otherwise "Hoàng Văn Khải" in $out/@types/node/package.json will be corrupted
    LOCALE_ARCHIVE = stdenv.lib.optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";
    LANG = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";

    installPhase = ''
      export HOME=$(mktemp -d)
      cd client
      cp ${./package-lock.json} ./package-lock.json
      npm install
      cp -r node_modules $out
    '';
    # remove non-determenistic prefixes of build-time pathes
    postFixup = ''
      for f in $(find $out -name package.json); do
        substituteInPlace $f --replace "\"$NIX_BUILD_TOP" "\"/build"
      done
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "14fdmmg3pmjsmxp7ljdfa9ddixard3lx8l6imk0an9pa2bxl00zm";
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
    platforms = [ "x86_64-linux" ]; # node-sass not available on "aarch64-linux"
  };
}
