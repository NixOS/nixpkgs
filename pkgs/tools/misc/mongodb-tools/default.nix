{ stdenv
, lib
, buildGoPackage
, fetchFromGitHub
, openssl
, pkgconfig
, libpcap
}:

let
  tools = [
    "bsondump"
    "mongoimport"
    "mongoexport"
    "mongodump"
    "mongorestore"
    "mongostat"
    "mongofiles"
    "mongotop"
    "mongoreplay"
  ];
  version = "4.2.0";

in buildGoPackage {
  pname = "mongo-tools";
  inherit version;

  goPackagePath = "github.com/mongodb/mongo-tools";
  subPackages = tools;

  src = fetchFromGitHub {
    rev = "r${version}";
    owner = "mongodb";
    repo = "mongo-tools";
    sha256 = "0mjwvx0cxvb6zam6jyr3753xjnwcygxcjzqhhlsq0b3xnwws9yh7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libpcap ];

  # Mongodb incorrectly names all of their binaries main
  # Let's work around this with our own installer
  buildPhase = ''
    # move vendored codes so nixpkgs go builder could find it
    runHook preBuild

    ${stdenv.lib.concatMapStrings (t: ''
      go build -o "$bin/bin/${t}" -tags ssl -ldflags "-s -w" $goPackagePath/${t}/main
    '') tools}

    runHook postBuild
  '';

  meta = {
    homepage = https://github.com/mongodb/mongo-tools;
    description = "Tools for the MongoDB";
    license = lib.licenses.asl20;
  };
}
