{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustcat";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/6vNFh7n6WvYerrL8m9sgUKsO2KKj7/f8xc4rzHy9Io=";
  };

  cargoSha256 = "sha256-wqoU9UfXDmf7KIHgFif5rZfZY8Zu0SsaMVfwTtXLzHg=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Port listener and reverse shell";
    homepage = "https://github.com/robiot/rustcat";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "rcat";
  };
}
