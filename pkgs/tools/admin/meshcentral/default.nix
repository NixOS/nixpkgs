<<<<<<< HEAD
{ lib, fetchzip, yarn2nix-moretea, nodejs_18, dos2unix }:

yarn2nix-moretea.mkYarnPackage {
  version = "1.1.6";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.6.tgz";
    sha256 = "03f2jyjrxmmr28949m3niwb437akyp6kg6h1m2jkaxfg5yj4hs4v";
=======
{ lib, fetchpatch, fetchzip, yarn2nix-moretea, nodejs_16, jq, dos2unix }:

yarn2nix-moretea.mkYarnPackage {
  version = "1.1.5";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.5.tgz";
    sha256 = "1djdqfcmfk35q7hfbdn4rnh4di2lk1gk7icfasjmihrgpnsxrrir";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    sed -i '1i#!${nodejs_18}/bin/node' $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
=======
    sed -i '1i#!${nodejs_16}/bin/node' $out/libexec/meshcentral/deps/meshcentral/meshcentral.js
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
