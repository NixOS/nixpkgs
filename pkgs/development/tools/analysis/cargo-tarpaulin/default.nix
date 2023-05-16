<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.26.1";
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.25.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-FQdYos8hnQMkl/3vM9kSj0LM8fIZcsWMLKimpNXnrFo=";
  };

  cargoHash = "sha256-fCoZ1pSKPXvNSWiAfhPygidkM0Ek7DYtHHv/sdPptvM=";

=======
    sha256 = "sha256-EJb9IVQClZwJrIorJ6FM6gDV5oSeXiwbwG9l6+4fMQ8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

<<<<<<< HEAD
=======
  cargoHash = "sha256-WnvMLi0GeeLsmHDxH0tGAQfX//x9GD2cd/m7Tp/GLGA=";
  #checkFlags = [ "--test-threads" "1" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
<<<<<<< HEAD
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda hugoreeves ];
=======
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
