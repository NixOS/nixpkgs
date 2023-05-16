<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "6.0.0";
=======
{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "5.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-EzXpiJGTAlTDHJwl7FwIsDHMqStj2PLD1PHmv0flBKc=";
  };

  cargoHash = "sha256-l1W+eYuKnMPN2wPhYPXo5ixUz2bX+FZnDazk+FbxquU=";
=======
    sha256 = "01aqqjynfcrn3m36hfjwcfh870imcd0hj5gifxzpnjiqjwpvys59";
  };

  cargoSha256 = "1n4gmqmi975cd2zyrf0yi4gbxjjg9f99xa191mgmrdyyij7id3cf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
