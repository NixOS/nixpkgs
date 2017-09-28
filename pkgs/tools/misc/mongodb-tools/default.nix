{ stdenv, lib, buildGoPackage, fetchFromGitHub, openssl_1_0_2, pkgconfig, libpcap }:

let
  tools = [
    "bsondump" "mongodump" "mongoexport" "mongofiles" "mongoimport"
    "mongooplog" "mongorestore" "mongostat" "mongotop"
  ];
in
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
  
  buildInputs = [ pkgconfig openssl_1_0_2 libpcap ];
  
 
  buildPhase = ''
    ./go/src/github.com/mongodb/mongo-tools/build.sh ssl
  '';
  
  buildFlags = [ "-tags ssl" ];
  
  allowGoReference = true;
  

  # Mongodb incorrectly names all of their binaries main
  # Let's work around this with our own installer
  preInstall = ''
    mkdir -p $bin/bin
  '' + toString (map (t: ''
      go install $goPackagePath/${t}/main
      mv go/bin/main $bin/bin/${t}
  ''
  ) tools) + ''  
    rm -r go/bin
  '';
}
