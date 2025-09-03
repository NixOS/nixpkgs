{
  lib,
  fetchzip,
  fetchYarnDeps,
  yarn2nix-moretea,
  nodejs_20,
  dos2unix,
}:

yarn2nix-moretea.mkYarnPackage {
  version = "1.1.49";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.49.tgz";
    sha256 = "1xklg7snn3qlmakkqy89q58n7b09idxz0zz5ha3hrn8s0wcmjakr";
  };

  patches = [
    ./fix-js-include-paths.patch
  ];

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-xiZ1RL4GsihQc1yazjkTfge/DS2N9oimSl0EZr6WmrM=";
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
    sed -i '1i#!${nodejs_20}/bin/node' $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
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
