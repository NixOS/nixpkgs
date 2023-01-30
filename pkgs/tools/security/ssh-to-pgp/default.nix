{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-5Wg0ItAkAb0zlhzcuDT9o0XIIbG9kqk4mIYb6hSJlsI=";
  };

  vendorSha256 = "sha256-OMWiJ1n8ynvIGcmotjuGGsRuAidYgVo5Y5JjrAw8fpc=";

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
