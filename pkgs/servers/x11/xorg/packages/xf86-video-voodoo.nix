{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-voodoo";
  version = "1.2.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-voodoo";
    rev = "refs/tags/xf86-video-voodoo-1.2.6";
    hash = "sha256-OuKGgrdGIIUF6CHD1BwO7ZQgvcbhGHQETExv+Ra0X2E=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
