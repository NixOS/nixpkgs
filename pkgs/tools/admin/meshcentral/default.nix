{
  lib,
  fetchzip,
  fetchYarnDeps,
  yarn2nix-moretea,
  nodejs_20,
  dos2unix,
}:

yarn2nix-moretea.mkYarnPackage {
<<<<<<< HEAD
  version = "1.1.54";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.54.tgz";
    sha256 = "0p33bcf8n981mlkvds28y78cc7lsxpdlxcdbdqgk2ch6h04vyzcr";
=======
  version = "1.1.53";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.53.tgz";
    sha256 = "1wjmvw7cymyjx0hii7kzmmrn7lmc3lj0hsll1nz32z11gnixdvbq";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    ./fix-js-include-paths.patch
  ];

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
<<<<<<< HEAD
    hash = "sha256-t5lSKw6PX+mrQxYiglUsyWtqo0SGe3yYGFLA+bvCEPU=";
=======
    hash = "sha256-jrBRexn5xc0OiBDf9fFDe2ZB3PcFVSuOChGCUWU4hcs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  doDist = false;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  publishBinsFor = [ ];

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "meshcentral";
  };
}
