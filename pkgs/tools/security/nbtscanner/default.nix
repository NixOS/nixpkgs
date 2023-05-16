{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nbtscanner";
<<<<<<< HEAD
  version = "0.0.2";
=======
  version = "0.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jonkgrimes";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-lnTTutOc829COwfNhBkSK8UpiNnGsm7Da53b+eSBt1Q=";
  };

  cargoHash = "sha256-NffNQXKJ+b1w7Ar2M6UDev/AxruDEf8IGQ+mNdvU6e4=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];
=======
    sha256 = "06507a8y41v42cmvjpzimyrzdp972w15fjpc6c6750n1wa2wdl6c";
  };

  cargoSha256 = "0cis54zmr2x0f4z664lmhk9dzx00hvds6jh3x417308sz7ak11gd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "NetBIOS scanner written in Rust";
    homepage = "https://github.com/jonkgrimes/nbtscanner";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
