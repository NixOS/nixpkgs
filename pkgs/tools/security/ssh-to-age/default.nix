{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-cEEFz/iVhvfo8CffC9wkIRnF26xL+roaqKsLmUgfUiA=";
  };

  vendorHash = "sha256-FH+etKil0oiiB5tvDYS2nu1HG4yZTWZuRhtYnbq4Os4=";

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
