{ lib, stdenv, fetchFromGitHub, pkg-config, rustPlatform, Security, curl, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
<<<<<<< HEAD
  version = "0.2.3";
=======
  version = "0.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-8mnCwWwReNH9s/gbxIhe7XdJRIA6BSUKm5jzykU5qMU=";
  };

  cargoHash = "sha256-J4AylYE4RTRPTUz5Hek7D34q9HjlFnrc/z/ax0i6lPQ=";
=======
    sha256 = "sha256-hUTBDC2XU82jc9TbyCYVKgWxrKG/OIc1a+fEdj5566M=";
  };

  cargoSha256 = "sha256-cU/X+oNTMjUSODkdm+P+vVLmBJlkeQ9WTJGvQmUOQKw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Discover funding links for your project's dependencies";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ johntitor ];
  };
}
