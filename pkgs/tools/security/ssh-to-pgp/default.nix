{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-3R/3YPYLdirK3QtiRNO2tpJRO2DKgN+K4txb9xwnQvQ=";
  };

  vendorHash = "sha256-RCz2+IZdgmPnEakKxn/C3zFfRyWnMLB51Nm8VGOxBkc=";

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
