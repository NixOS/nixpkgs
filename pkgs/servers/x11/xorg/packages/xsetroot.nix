{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsetroot";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xsetroot";
    rev = "refs/tags/xsetroot-1.1.3";
    hash = "sha256-4UpjRJ2AkqTyp16ayU7fvBZWmpGj1Ey6LYiw92z3ZJw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
