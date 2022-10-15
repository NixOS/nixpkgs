{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pIbhrYiZOZ0GoynnHvp+h5E4O4syiwVhQeczAv1zjTo=";
  };

  cargoHash = "sha256-2aFvFP64vy0FK0k0Uq6sPVi42E5easxOUlkcZjrjoMs=";

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
