{ stdenv, buildGoPackage, fetchFromGitHub, openssl_1_0_2, pkgconfig, libpcap }:

let
  tools = [
    "bsondump" "mongodump" "mongoexport" "mongofiles" "mongoimport"
    "mongooplog" "mongorestore" "mongostat" "mongotop"
  ];
in

with stdenv.lib;

buildGoPackage rec {
  name = "mongo-tools-${version}";
  version = "3.5.13";
  rev = "r${version}";

  goPackagePath = "github.com/mongodb/mongo-tools";
  subPackages = map (t: t + "/main") tools;

  src = fetchFromGitHub {
    inherit rev;
    owner = "mongodb";
    repo = "mongo-tools";
    sha256 = "00klm4pyx5k39nn4pmfrpnkqxdhbzm7lprgwxszpirzrarh2g164";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl_1_0_2 libpcap ];

  # Mongodb incorrectly names all of their binaries main
  # Let's work around this with our own installer
  buildPhase = ''
    runHook preBuild
    ${stdenv.lib.concatMapStrings (t: ''
      go build -o "$bin/bin/${t}" -tags ssl -ldflags "-s -w" $goPackagePath/${t}/main
    '') tools}
    runHook postBuild
  '';

  meta = {
    homepage = https://github.com/mongodb/mongo-tools;
    description = "Tools for the MongoDB";
    license = licenses.asl20;
  };
}
