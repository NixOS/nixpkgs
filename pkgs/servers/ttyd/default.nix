{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake, xxd
, openssl, libwebsockets, json_c, libuv, zlib
, python3, nodejs-slim, yarn, fixup_yarn_lock
, callPackage
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.6.3";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = version;
    sha256 = "0yks0dz0prajvq6aksznih6ggxf337c1amhkj5flkn7cv3vrvd8j";
  };

  nativeBuildInputs = [ pkg-config cmake xxd yarn nodejs-slim python3 ];
  buildInputs = [ openssl libwebsockets json_c libuv zlib ];

  # The file src/html.h in the ttyd repository is generated from the frontend
  # source in the html/ subdirectory. Instead of using this pre-built file, we
  # generate it ourselves. We do this not only to keep everything honest, but
  # also to facilitate easy overriding/patching of this package. Changes to the
  # html/ subdirectory wouldn't have any effect without regenerating src/html.h.
  preBuild =
    let
      yarnNix = callPackage ./yarn.nix {};
      offline_cache = yarnNix.offline_cache;
    in ''
      (
        cd ../html
        export HOME=$PWD/yarn_home

        yarn config --offline set yarn-offline-mirror ${offline_cache}
        ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

        export npm_config_nodedir=${nodejs-slim}
        yarn install --offline --no-progress

        # `yarn build` executes ./node_modules/bin/webpack, which is a symlink
        # to ./node_modules/webpack/bin/webpack.js, which starts with the usual
        # `/usr/bin/env`, which doesn't exist in the sandbox.
        patchShebangs node_modules
        yarn build --offline
      )
    '';

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Share your terminal over the web";
    homepage    = "https://github.com/tsl0922/ttyd";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice iblech ];
    platforms   = platforms.linux;
  };
}
