{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlsfonts";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlsfonts";
    rev = "refs/tags/xlsfonts-1.0.7";
    hash = "sha256-YNXj/p4g0y0tEFylKgz0COxVFiVqeTm0MqU98HH7qAA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
