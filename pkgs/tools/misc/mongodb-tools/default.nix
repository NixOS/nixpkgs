{ lib, buildGoModule, fetchFromGitHub, openssl, pkg-config, libpcap }:

buildGoModule rec {
  pname = "mongo-tools";
<<<<<<< HEAD
  version = "100.7.3";
=======
  version = "100.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-tools";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Ls2/P+0aqnTN4alP36aJ+86BjOZoULEuPMyW7NX5px8=";
=======
    sha256 = "sha256-m7Xn8RHCmnvT6S1694O+k8ZYSR9opN+/oYUG2yaZIMg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
