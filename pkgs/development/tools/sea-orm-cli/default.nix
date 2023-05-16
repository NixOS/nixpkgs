{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
<<<<<<< HEAD
  version = "0.12.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mg0PkWxlfwo4eAtbU1ZOphEUBB1P6VsSpODyJZhvwQs=";
=======
  version = "0.11.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VRSdPsjRubJOsjdAxdnFCM9VmAVwGkXDvpXT4GF2jxY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

<<<<<<< HEAD
  cargoHash = "sha256-6LXJtY844CyR6H0/IkEJrpSj4UNWcpO/XoTzUthcTUc=";
=======
  cargoHash = "sha256-4lPtj11Gc+0r2WQT8gx8eX+YK5L+HnUBR0w6pm3VlRQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
