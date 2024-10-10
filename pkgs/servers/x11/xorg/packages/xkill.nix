{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkill";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkill";
    rev = "refs/tags/xkill-1.0.6";
    hash = "sha256-0i0BTV5RoZXmR9Hdz6r6qmEekA4HuCH98ePXkHY+PkU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
