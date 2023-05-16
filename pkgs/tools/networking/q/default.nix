{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
<<<<<<< HEAD
  version = "0.11.4";
=======
  version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-zoIHpj1i0X5SCVhcT3bl5xxsDcvD2trEVhlIC5YnIZo=";
  };

  vendorHash = "sha256-cZRaf5Ks6Y4PzeVN0Lf1TxXzrifb7uQzsMbZf6JbLK4=";
=======
    sha256 = "sha256-kS3t4bAvxFoZBE5UMM5yJ0WbsN6MqkEYhkl8wiBJKQg=";
  };

  vendorHash = "sha256-jjhDD0qZh4QHjFO14+FsRFxEywByHB2gIxy/w3QOWBk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
