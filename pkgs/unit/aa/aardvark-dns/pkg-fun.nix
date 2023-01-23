{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tQTa/iIo7kpcQq1p2romoOG2qNOiSDH7DHx3iZYLY8w=";
  };

  cargoHash = "sha256-naWkSXQHfImd6R+RHKkmTe8UiqxknZEFYoJ0g/URCVY=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
