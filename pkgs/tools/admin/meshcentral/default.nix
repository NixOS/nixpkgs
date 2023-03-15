{ lib, fetchpatch, fetchzip, yarn2nix-moretea, nodejs-16_x, jq, dos2unix }:

yarn2nix-moretea.mkYarnPackage {
  version = "1.1.4";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.4.tgz";
    sha256 = "1q13d01ar3nhg3v7w22byn02sga5qkzxbjzpzp30qrvb3gx8prmp";
  };

  patches = [ ./fix-js-include-paths.patch ];

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  # Tarball has CRLF line endings. This makes patching difficult, so let's convert them.
  nativeBuildInputs = [ dos2unix ];
  prePatch = ''
    find . -name '*.js' -exec dos2unix {} +
    ln -snf meshcentral.js bin/meshcentral
  '';

  preFixup = ''
    mkdir -p $out/bin
    chmod a+x $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
    sed -i '1i#!${nodejs-16_x}/bin/node' $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
    ln -s $out/libexec/meshcentral/deps/meshcentral/meshcentral.js $out/bin/meshcentral
  '';

  publishBinsFor = [ ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/info/";
    maintainers = [ maintainers.lheckemann ];
    license = licenses.asl20;
  };
}
