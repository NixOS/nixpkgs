{ lib
, stdenv
, fetchurl
, runCommand
, fetchCrate
, rustPlatform
, Security
, openssl
, pkg-config
, SystemConfiguration
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "duckscript_cli";
<<<<<<< HEAD
  version = "0.8.20";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-o9GKcRBtQn0m8pQHlokACGVBArd4khtoJ6e4Q2hcT14=";
=======
  version = "0.8.18";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-AbdGyRCeypmsBc2QdR4Tdl3MeUlK9xmNmB63axpUfFI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

<<<<<<< HEAD
  cargoHash = "sha256-dG7bBg/pRcSWWV0NK8gWbXAmsNipHQKUwmTHHFdUsrc=";
=======
  cargoHash = "sha256-Exsgt1yV3EiEewzDU4YLhSYGpzr4t2o5hm3evyAkO44=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language.";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
