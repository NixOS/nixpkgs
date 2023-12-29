{ lib, buildGoModule, fetchFromGitHub, openssl, pkg-config, libpcap }:

buildGoModule rec {
  pname = "mongo-tools";
  version = "100.9.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-tools";
    rev = version;
    sha256 = "sha256-l3A7ykkQCkT34EdgpcSJpFsZq1gE9GII9gzaXJaUwEk=";
  };

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libpcap ];

  # Mongodb incorrectly names all of their binaries main
  # Let's work around this with our own installer
  buildPhase =
    let
      tools = [
        "bsondump"
        "mongodump"
        "mongoexport"
        "mongofiles"
        "mongoimport"
        "mongorestore"
        "mongostat"
        "mongotop"
      ]; in
    ''
      # move vendored codes so nixpkgs go builder could find it
      runHook preBuild

      ${lib.concatMapStrings (t: ''
        go build -o "$out/bin/${t}" -tags ssl -ldflags "-s -w" ./${t}/main
      '') tools}

      runHook postBuild
    '';

  meta = {
    homepage = "https://github.com/mongodb/mongo-tools";
    description = "Tools for the MongoDB";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bryanasdev000 ];
  };
}
