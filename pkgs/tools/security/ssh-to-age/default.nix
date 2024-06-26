{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-NHNjBMK4eJZSZMOg75VmpD6mVQaRJbk5GoJST9W6j4w=";
  };

  vendorHash = "sha256-JpZ+cdDQ3yfH0EAyzi3HO7bozGYJgCYFf2KO/lXwCf8=";

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys in ed25519 format to age keys";
    homepage = "https://github.com/Mic92/ssh-to-age";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "ssh-to-age";
  };
}
