{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, SystemConfiguration
, Security
, CoreFoundation
, curl
, libiconv
, openssl
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
<<<<<<< HEAD
  version = "0.24.3";
=======
  version = "0.23.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-CCTG58dwO9gYe0WSUXFeaBSgvZ7pbX9S3B3hzabzkjo=";
  };

  cargoHash = "sha256-p2qAWAZ1Y0GI0t9wHmn5Ww3o5vXpA6rsA/D7HD2x6o0=";
=======
    sha256 = "sha256-wMF2uF6h06c/vBBXr2IGk/9RsOxnxvffEtIOR+s+iVk=";
  };

  cargoSha256 = "sha256-UF0bEV77IqGBmqGCqg2cHzom7JDRqlLpoSxbNQsKKiY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ SystemConfiguration Security CoreFoundation libiconv curl ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ b4dm4n matthiasbeyer ];
=======
    maintainers = with maintainers; [ b4dm4n ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
