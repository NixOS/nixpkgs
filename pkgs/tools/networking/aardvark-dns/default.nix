{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bScL8hFV/Kot7P9nJRMDDhB8pllPUsejtJpbjmQ8skI=";
  };

  cargoHash = "sha256-rrn+ZTAsFs7UTP4xQL3Cy8G6RG7vwT0wMKnXHHIkB90=";

  patches = [
    (fetchpatch { # https://github.com/containers/aardvark-dns/issues/379
      url = "https://github.com/containers/aardvark-dns/commit/b13f0434f410934b515f086334414c6f5f55096e.diff";
      hash = "sha256-6XReIShEe8+WKc5jK5NzCNMEd4INdOn9Sf8UrQLbj+s=";
    })
  ];

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
