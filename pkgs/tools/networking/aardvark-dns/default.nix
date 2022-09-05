{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HxikpGeQlwulSedFCwWLADHKMlFrsgC7bMoZ1OxGCUE=";
  };

  cargoHash = "sha256-uP9caaOdFWs73T8icHE9uXNo63NdZrQ5afXFb4Iy1+I=";

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
