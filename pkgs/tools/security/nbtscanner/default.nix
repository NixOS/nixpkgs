{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nbtscanner";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "jonkgrimes";
    repo = pname;
    rev = version;
    hash = "sha256-lnTTutOc829COwfNhBkSK8UpiNnGsm7Da53b+eSBt1Q=";
  };

  cargoHash = "sha256-NffNQXKJ+b1w7Ar2M6UDev/AxruDEf8IGQ+mNdvU6e4=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "NetBIOS scanner written in Rust";
    homepage = "https://github.com/jonkgrimes/nbtscanner";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
