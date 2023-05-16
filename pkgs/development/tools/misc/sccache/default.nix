{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
<<<<<<< HEAD
  version = "0.5.4";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-CaZM8c1dref98VL240PEUQE8XtWAvVlQSGnPQspg+jw=";
  };

  cargoSha256 = "sha256-F4lnE5ig3UnZJOdxpnGLesDP3rgEOFzZO0WGQ8mtj+o=";
=======
    sha256 = "sha256-OXCR052syGpqeIHviKAqS5LEAt8epdlFFarkVdmfa0I=";
  };

  cargoSha256 = "sha256-hYNnzVhw0yCqgRcRJCZusuY+g+MZn1DD5pfDTJlTv+w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = with lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${version}";
    maintainers = with maintainers; [ doronbehar figsoda ];
    license = licenses.asl20;
  };
}
