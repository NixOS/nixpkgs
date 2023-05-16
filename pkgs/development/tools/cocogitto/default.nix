{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, libgit2 }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
<<<<<<< HEAD
  version = "5.5.0";
=======
  version = "5.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-kzG22TDWGmqXuX9wr4w6PP0chbjAEqQO38jF8BGVu6w=";
  };

  cargoHash = "sha256-sBwR0I8eNEBglPSeSNqc7qv3eXbzcgZNBPC74Kulhbw=";
=======
    sha256 = "sha256-Z0snC5NomUWzxI2qcRMxdZbC1aOQ8P2Ll9EdVfhP7ZU=";
  };

  cargoHash = "sha256-P/xwE3oLVsIoxPmG+S0htSHhZxCj79z2ARGe2WzWCEo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Test depend on git configuration that would likely exist in a normal user environment
  # and might be failing to create the test repository it works in.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libgit2 ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)
  '';

  meta = with lib; {
    description = "A set of cli tools for the conventional commit and semver specifications";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
