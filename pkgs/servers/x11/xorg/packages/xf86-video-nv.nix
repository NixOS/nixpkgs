{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nv";
  version = "2.1.22";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nv";
    rev = "refs/tags/xf86-video-nv-2.1.22";
    hash = "sha256-1iQwdle0ehy+lmxJxibHshgtuSGrEU/qu/hN4rmGmQQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
