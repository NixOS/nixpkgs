{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-vmmouse";
  version = "13.2.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-vmmouse";
    rev = "refs/tags/xf86-input-vmmouse-13.2.0";
    hash = "sha256-SasWsIzq9s8i3dabRwKGZ0NSuFqnUu4WCWYTu/ZZpS8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
