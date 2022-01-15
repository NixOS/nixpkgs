{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "08yynwmn1kzanabiqzysyk9jbn0zyjjlilj4b4j5m29hfykq1jvf";
  };

  cargoSha256 = "19rbmiy71hgybzfwpz4msqqgl98qv9c3x06mjcpmixq4qhgxz616";

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
  };
}
