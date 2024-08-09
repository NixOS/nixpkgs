{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwininfo";
  version = "1.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xwininfo";
    rev = "refs/tags/xwininfo-1.1.6";
    hash = "sha256-kdo6+jsHO0VTD7W3wkcJ+hSAui7cr8ZKGRN/tT6C5Ks=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
