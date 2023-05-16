<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "morsel";
  version = "0.1.1";
=======
{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "morsel";
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SamLee514";
    repo = "morsel";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bb+88GIyd92kHJAs25mJ9vmq0Ha2q0fdHnpTXhX2BFE=";
  };

  cargoHash = "sha256-XRl71n+rV6MTQMz957K5/25SX9HvYVW6qAuHTdfRLLs=";
=======
    sha256 = "sha256-m4bCni/9rMTPhZSogpd5+ARrW11TPHSvQpdz3wUr9H4=";
  };

  cargoSha256 = "sha256-2xR2/013ocDKWS1oWitpAbSDPRwEJJqFcCIm6ZQpCoc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command line tool to translate morse code input to text in real time";
    homepage = "https://github.com/SamLee514/morsel";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
