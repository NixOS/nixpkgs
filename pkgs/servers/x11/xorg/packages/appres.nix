{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appres";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "appres";
    rev = "refs/tags/appres-1.0.6";
    hash = "sha256-X7dUWuZXjfBdDePkBoYgKQfV5UAzj9EZcOSA04Mi0TM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
