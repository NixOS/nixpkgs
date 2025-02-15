{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libX11";
  version = "1.8.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libX11";
    rev = "refs/tags/libX11-1.8.7";
    hash = "sha256-4Q0gf+XGBBQDVqvi9931jrY6+iXWtPUls22oI6gCHVE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
