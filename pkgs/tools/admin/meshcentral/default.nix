{ lib
, fetchzip
, fetchpatch
, fetchYarnDeps
, yarn2nix-moretea
, nodejs_18
, dos2unix
}:

yarn2nix-moretea.mkYarnPackage {
  version = "1.1.33";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.33.tgz";
    sha256 = "0s362iwnwmfpz5gbjnvjwccchx03hl53v6yqyyy34vy4f1mxvyim";
  };

  patches = [
    ./fix-js-include-paths.patch

    # With this change, meshcentral fails to detect installed dependencies
    # and tries to install those at runtime. Hence, reverting.
    (fetchpatch {
      hash = "sha256-MtFnU1FI7wNBiTGmW67Yn4oszviODcAJOL1PIi78+ic=";
      url = "https://github.com/Ylianst/MeshCentral/commit/cfe9345b53fcd660985d7ce7b82278182b40f41e.patch";
      revert = true;
    })
  ];

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-W1MMZRDoeBJ3nGzXFVPGsrAtk4FlQGTUhFpPCdpdHPI=";
  };

  # Tarball has CRLF line endings. This makes patching difficult, so let's convert them.
  nativeBuildInputs = [ dos2unix ];
  prePatch = ''
    find . -name '*.js' -exec dos2unix {} +
    ln -snf meshcentral.js bin/meshcentral
  '';

  preFixup = ''
    mkdir -p $out/bin
    chmod a+x $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
    sed -i '1i#!${nodejs_18}/bin/node' $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
    ln -s $out/libexec/meshcentral/deps/meshcentral/meshcentral.js $out/bin/meshcentral
  '';

  publishBinsFor = [ ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
    mainProgram = "meshcentral";
  };
}
