{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N439ubEayoyfGrzkXE7+TeJQkddy8PZn5Lhmc/X5VxU=";
  };

  cargoHash = "sha256-cIHz672jd8NKLyLvwsZInLerdA9MXRgWdpJFgMSgs9Q=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
