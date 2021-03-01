{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-TDrpnWAez8muysMdmKFBDZfK8CyhGn1VqHB8+zD6jSk=";
  };

  vendorSha256 = "sha256-ZF/WsmqmGHZIAGTPKJ70UhtmssNhiInEZfzrKxQLw9I=";

  checkInputs = [ gnupg ];
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
