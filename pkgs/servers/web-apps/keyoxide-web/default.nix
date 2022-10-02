{ stdenv
, lib
, nodejs-16_x
, fetchYarnDeps
, mkYarnPackage
, makeWrapper
, callPackage
}:
let
  nodejs = nodejs-16_x;

  pname = "keyoxide-web";
  version = lib.fileContents ./version;

  src = fetchTarball {
    url = "https://codeberg.org/keyoxide/${pname}/archive/${version}.tar.gz";
    sha256 = lib.fileContents ./package-hash;
  };
in
  mkYarnPackage {
    inherit pname version nodejs src;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = lib.fileContents ./deps-hash;
    };

    # Make node_modules writable
    configurePhase = ''
      cp -r $node_modules node_modules
      chmod +w node_modules
    '';

    # Perform custom build phases in package.json
    # jsdom needs to be installed from the yarn cache
    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn --offline run build
    '';

    # Manual install similar to Dockerfile method
    # Must copy across node_modules in order to make jsdom available.
    # Can remove this once ncc can handle jsdom appropriately.
    # https://github.com/jsdom/jsdom/issues/2508
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir $out
      cp -r package.json $out
      cp -r dist $out
      cp -r content $out
      cp -r views $out
      cp -r static $out
      cp -r node_modules $out
      makeWrapper $nodejs/bin/node $out/bin/keyoxide-web --chdir $out --add-flags "--experimental-fetch ./dist"
    '';

    doDist = false;

    passthru = {
      tests = {
        inherit (nixosTests);
      };
      updateScript = callPackage ./update.nix {};
    };

    meta = with lib; {
      homepage = "https://keyoxide.org";
      description = "A modern, secure and decentralized platform to prove your online identity.";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ brinkofbailout ];
    };
  }

