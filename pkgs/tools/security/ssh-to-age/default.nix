{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-KdPeV4j9x/nQtvmw90wvf62VxwXPGtKg8aSOM3YBT64=";
  };

  vendorSha256 = "sha256-1iDFM6KNsvvwOTg05TAJZvHVTv+Gc0nG0STzNdk0NB4=";

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
