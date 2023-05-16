{ lib, buildGoModule, fetchFromGitHub }:

let
<<<<<<< HEAD
  version = "1.21.0";
=======
  version = "1.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-BJKqVSyMjTedMuao8Bz92+B64B/x3M3MXKbSF+d0kDE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AnPC0x5V8ce9KH0B4Ujz2MrTIJA+P/BZG+fsRJ3LM78=";
=======
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-5MC7D9+33x/l76j186FCnzo0Hnx0wY6BPdneW7E7MpE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-gDePB+IZSyVIILDAj+O0Q8hgL0N/0Mwp1Xsrlh3B914=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
