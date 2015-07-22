{ lib, goPackages, fetchurl, callPackage }:

with goPackages;

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
    oglematchers goconvey tomb ];

  subPackages = [ "bsondump/main" "mongostat/main" "mongofiles/main"
    "mongoexport/main" "mongoimport/main" "mongorestore/main"
    "mongodump/main" "mongotop/main" "mongooplog/main" ];

  buildPhase = ''
    for i in bsondump mongostat mongofiles mongoexport mongoimport mongorestore mongodump mongotop mongooplog; do
      echo Building $i
      go build -o go/bin/$i go/src/${goPackagePath}/$i/main/$i.go
    done
  '';

  dontInstallSrc = true;

  meta = with lib; {
    description = "Tools for MongoDB";
    homepage = https://github.com/mongodb/mongo-tools;
    license = licenses.asl20;
    maintainers = with maintainers; [ mschristiansen ];
    platforms = platforms.linux;
  };
}
