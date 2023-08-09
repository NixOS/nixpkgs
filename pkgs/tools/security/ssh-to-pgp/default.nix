{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-WdSa7rLUGcn1XZSnbwglp4I432XzB3vXb6IO3biE+Js=";
  };

  vendorHash = "sha256-J9HuZhjeXSS4ej1RM+yn2VGoSdiS39PDM4fScAh6Eps=";

  nativeCheckInputs = [ gnupg ];
  checkPhase = ''
    HOME=$TMPDIR go test .
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys to PGP";
    homepage = "https://github.com/Mic92/ssh-to-pgp";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
