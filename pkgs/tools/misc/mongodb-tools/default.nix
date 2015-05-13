{ lib, goPackages, fetchurl, callPackage }:

with goPackages;

let
  goconvey = callPackage ./goconvey.nix {};
  openssl  = callPackage ./openssl.nix {};
  oglematchers = callPackage ./oglematchers.nix {};
in
buildGoPackage rec {
  version = "r3.1.2";
  name = "mongodb-tools";
  goPackagePath = "github.com/mongodb/mongo-tools";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/mongodb/mongo-tools/archive/${version}.tar.gz";
    sha256 = "1dag8ar95jlfk6rm99y4p3dymcy2s2qnwd9jwqhw9fxr110mgf5s";
  };

  buildInputs = [ gopass go-flags crypto mgo openssl spacelog
    oglematchers goconvey ];

  subPackages = [ "mongorestore/main" ];
  # subPackages = [ "mongorestore/main" "mongodump/main" "mongostat/main" ];

  # TODO: Write a build phase that renames each subPackage to the tool
  # name rather than main.

  dontInstallSrc = true;

  meta = with lib; {
    description = "Tools for MongoDB";
    homepage = https://github.com/mongodb/mongo-tools;
    license = licenses.asl20;
    maintainers = with maintainers; [ mschristiansen ];
    platforms = platforms.linux;
  };
}
