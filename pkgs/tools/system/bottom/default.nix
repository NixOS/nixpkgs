{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
<<<<<<< HEAD
  version = "0.9.6";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-czOYEZevZD7GfExmqwB7vhLXl6+etag1PjZFA2G9aGA=";
  };

  cargoHash = "sha256-RDOGf1jujZikcRXRtL71BUGgmZyt7vQOTk1LkKpXDuo=";
=======
    sha256 = "sha256-/pjMxWQ66t9Jd8ziLJXDgnwfSgR1uS9U1uXVDTZze58=";
  };

  cargoHash = "sha256-0KweijC4gA9ELmQZ7lvOx2BypMuj8KsZHxGfcRXVi4g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  doCheck = false;

  postInstall = ''
    installManPage target/tmp/bottom/manpage/btm.1
    installShellCompletion \
      target/tmp/bottom/completion/btm.{bash,fish} \
      --zsh target/tmp/bottom/completion/_btm
  '';

  BTM_GENERATE = true;

  meta = with lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    changelog = "https://github.com/ClementTsang/bottom/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche figsoda ];
    mainProgram = "btm";
  };
}
