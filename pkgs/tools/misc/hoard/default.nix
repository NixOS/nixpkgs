<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = "hoard";
    rev = "v${version}";
    hash = "sha256-c9iSbxkHwLOeATkO7kzTyLD0VAwZUzCvw5c4FyuR5/E=";
  };

  cargoHash = "sha256-4EeeD1ySR4M1i2aaKJP/BNSn+t1l8ingiv2ZImFFn1A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];
=======
{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gm3X6/g5JQJEl7wRvWcO4j5XpROhtfRJ72LNaUeZRGc=";
  };

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-ZNhUqnsme1rczl3FdFBGGs+vBDFcFEELkPp0/udTfR4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
<<<<<<< HEAD
    changelog = "https://github.com/Hyde46/hoard/blob/${src.rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc figsoda ];
    mainProgram = "hoard";
=======
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
