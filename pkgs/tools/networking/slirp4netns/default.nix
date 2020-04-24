{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, glib
, libcap
, libseccomp
, libslirp
}:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "1p5cvq0jsjkl136b8cz3j552x01g96j38ygh6m8ss62bmyzb8ayc";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ glib libcap libseccomp libslirp ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
