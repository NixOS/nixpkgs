{ stdenv, lib, fetchFromGitHub, cyrus_sasl, openssl, go }:

let
  tools = [
    "bsondump" "mongodump" "mongoexport" "mongofiles" "mongoimport"
    "mongooplog" "mongorestore" "mongostat" "mongotop"
  ];
in
stdenv.mkDerivation rec {
  name = "mongo-tools-${version}";
  version = "3.5.8";
  rev = "r${version}";

  buildInputs = [ cyrus_sasl openssl go ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "mongodb";
    repo = "mongo-tools";
    sha256 = "00klm4pyx5k39nn4pmfrpnkqxdhbzm7lprgwxszpirzrarh2g164";
  };

  phases = ["buildPhase"];

  buildPhase = ''
    set -x
    mkdir -p $out/bin $out/build
    cp -r $src/* $out/build
    cd $out/build
    ls -la
    . ./set_gopath.sh
    ${
      toString (map (t: ''
        go build -o $out/bin/${t} -tags "ssl sasl" $src/${t}/main/${t}.go
      '') tools)
    }
  '';
}
