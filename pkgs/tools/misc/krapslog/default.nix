{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Y5OdRi9OhVeT04BnHCCcNBr1G9vxSFwvNl1aL38AFWQ=";
  };

  cargoHash = "sha256-fdrcV4XmxaWiAVOL51sRUfTEDnnCKduYgj7I5unLpRI=";
=======
    sha256 = "sha256-zBtoKU9OHo1hyCgyQVAb3fsEW/IHwISht8VAss7LLq4=";
  };

  cargoHash = "sha256-gZr79VmvZrGglF6aC6j2c45ueJytgUslzBT5fyM3/V8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
