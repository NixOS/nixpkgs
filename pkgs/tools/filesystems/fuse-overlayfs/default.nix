{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ngpC1KtUsIJOfpJ9dSqZn9XhKkJSpp2/6RBz/RlZ+A0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ fuse3 ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ] ++ teams.podman.members;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    mainProgram = "fuse-overlayfs";
  };
}
