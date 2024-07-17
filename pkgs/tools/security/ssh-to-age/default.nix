{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-wGtNaejzAOgOuYDEKz6xMCaoaHsiDuQZj0KKpcejphE=";
  };

  vendorHash = "sha256-w/REcFeH58DTQwgotxSBVR4y7aQ9rBDX2U0A4vJno7s=";

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
