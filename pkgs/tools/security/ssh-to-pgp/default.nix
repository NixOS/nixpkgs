{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-SoHKBuI3ROfWTI45rFdMNkHVYHa5nX1A0/ljgGpF8NY=";
  };

  vendorHash = "sha256-sHvb6jRSMXIUv1D0dbTJWmETCaFr9BquNmcc8J06m/o=";

  nativeCheckInputs = [ gnupg ];
  checkPhase = ''
    HOME=$TMPDIR go test .
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys to PGP";
    mainProgram = "ssh-to-pgp";
    homepage = "https://github.com/Mic92/ssh-to-pgp";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
