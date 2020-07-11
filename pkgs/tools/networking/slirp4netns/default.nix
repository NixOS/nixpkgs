{ stdenv
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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "0hj3jcl3b96ssp8di72ghsgk3dp8d5nkh3gkyg9j7h0z9fncl72f";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ glib libcap libseccomp libslirp ];

  enableParallelBuilding = true;

  passthru.tests.podman = nixosTests.podman;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
