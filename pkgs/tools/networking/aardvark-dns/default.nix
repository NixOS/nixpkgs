{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wlaOgWptD4qdaSRg6NNkQNARHMZe3z3QVoXjp133guQ=";
  };

  cargoHash = "sha256-BnIGoLIuV/uDaskMA8CeVX2McAHJPT+gchZsS0bQxjI=";

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
