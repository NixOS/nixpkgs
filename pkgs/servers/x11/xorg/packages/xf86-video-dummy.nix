{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-dummy";
  version = "0.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-dummy";
    rev = "refs/tags/xf86-video-dummy-0.4.1";
    hash = "sha256-lEqA716pg1mjTLEkHLITXJMZY9Vj8VByEs49ONNxpHs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
