{ lib, fetchFromGitHub, buildGoModule, gnupg }:

buildGoModule rec {
  pname = "ssh-to-pgp";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-3R/3YPYLdirK3QtiRNO2tpJRO2DKgN+K4txb9xwnQvQ=";
  };

  vendorHash = "sha256-RCz2+IZdgmPnEakKxn/C3zFfRyWnMLB51Nm8VGOxBkc=";
=======
    sha256 = "sha256-5Wg0ItAkAb0zlhzcuDT9o0XIIbG9kqk4mIYb6hSJlsI=";
  };

  vendorSha256 = "sha256-OMWiJ1n8ynvIGcmotjuGGsRuAidYgVo5Y5JjrAw8fpc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
