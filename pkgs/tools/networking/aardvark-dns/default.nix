{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m2uKTVRonnun+/V69RcPWkkRtDcoaiulMCQz0/CAdCw=";
  };

  cargoHash = "sha256-Z/OZgWlpwcdqns26ojTLPQBVNrwU/i86tZVx19sRUTw=";

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
