{ stdenv
, lib
, nodejs-16_x
, fetchgitLocal
, fetchYarnDeps
, mkYarnPackage
}:
let
  nodejs = nodejs-16_x;

  pname = "keyoxide-web";
  version = "3.4.6";

  src = fetchTarball {
    url = "https://codeberg.org/keyoxide/${pname}/archive/${version}.tar.gz";
    sha256 = "1jl93rqc0c1d5kw7yas7kabzwxdzba700gniaqyclbi8gxz5rq85";
  };
in
  mkYarnPackage rec {
    inherit pname version src nodejs;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = "ePKgLwpJas6krl8i5V5lH0zBM+0CYtTo5k5pduWa93s=";
    };

    # Make node_modules writable
    configurePhase = ''
      cp -r $node_modules node_modules
      chmod +w node_modules
    '';

    # Perform custom build phases in package.json
    #yarn --offline add jsdom --cache-folder ${offlineCache} --modules-folder node_modules
    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn --offline run build
    '';

    # Manual install similar to Dockerfile method
    installPhase = ''
      mkdir $out
      cp -r package.json $out
      cp -r dist $out
      cp -r content $out
      cp -r views $out
      cp -r static $out
    '';

    # Need to install jsdom somehow

    doDist = false;

    meta = with lib; {
      homepage = "https://keyoxide.org";
      description = "A modern, secure and decentralized platform to prove your online identity.";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ brinkofbailout ];
    };
  }

