{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, CoreServices, Security, libiconv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
<<<<<<< HEAD
  version = "0.1.42";
=======
  version = "0.1.39";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8CQnmUk7jMlcdtZh6046B5duKnZKaMVk2xG4D2svqVw=";
  };

  cargoHash = "sha256-e3ku9c4VLZtnJIUDRMAcUVaJnOsMqckj3XmuJHSR364=";
=======
    sha256 = "sha256-/TAgAwP4y3MBIvcgCi2SiMfQ61BrFYuUY2LTg8mJn7U=";
  };

  cargoHash = "sha256-RGIqFTi0CFiPLMI3K7hsWMJXDrjVNbGnS7ZfTeBTPn0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv SystemConfiguration ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ b4dm4n matthiasbeyer ];
=======
    maintainers = with maintainers; [ b4dm4n ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
