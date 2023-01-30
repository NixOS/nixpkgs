{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-S7iWwRyJfxG38ym5j0b9xwC0tCNhQE+X/UuHG1wFVXo=";
  };

  vendorHash = "sha256-ZOa352gtigbuEQHw6i9Mnh2MD6+8IHOJOg7WJCH+Q88=";

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
    platforms = platforms.unix;
  };
}
