{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, glib
, libcap
, libseccomp
, libslirp
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "sha256-jUxAkC9nMiDiHKyKtmdtOEyb9jqOEiy5D3NqymluX28=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ glib libcap libseccomp libslirp ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
