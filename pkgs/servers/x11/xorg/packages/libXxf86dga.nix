{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXxf86dga";
  version = "1.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXxf86dga";
    rev = "refs/tags/libXxf86dga-1.1.6";
    hash = "sha256-+/b1ytGvjcJura9PQoHjr1L0Iznbb0G3cGKN3KabTf0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
