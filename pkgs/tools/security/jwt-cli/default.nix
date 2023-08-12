{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "sha256-EzXpiJGTAlTDHJwl7FwIsDHMqStj2PLD1PHmv0flBKc=";
  };

  cargoHash = "sha256-l1W+eYuKnMPN2wPhYPXo5ixUz2bX+FZnDazk+FbxquU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/jwt --version > /dev/null
    $out/bin/jwt decode eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c \
      | grep -q 'John Doe'
  '';

  meta = with lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
    mainProgram = "jwt";
  };
}
