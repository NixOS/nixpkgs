{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let
  tools = [
    "bsondump" "mongodump" "mongoexport" "mongofiles" "mongoimport"
    "mongooplog" "mongorestore" "mongostat" "mongotop"
  ];
in
buildGoPackage rec {
  name = "mongo-tools-${version}";
  version = "3.0.12";
  rev = "r${version}";

  goPackagePath = "github.com/mongodb/mongo-tools";
  subPackages = map (t: t + "/main") tools;

  src = fetchFromGitHub {
    inherit rev;
    owner = "mongodb";
    repo = "mongo-tools";
    sha256 = "142vxgniri1mfy2xmfgxhbdp6k6h8c5milv454krv1b51v43hsbm";
  };

  goDeps = ./deps.json;

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
