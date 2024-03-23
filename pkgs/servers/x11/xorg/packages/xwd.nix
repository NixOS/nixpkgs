{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwd";
  version = "1.0.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xwd";
    rev = "refs/tags/xwd-1.0.9";
    hash = "sha256-cEKm0c50qwWzGSkH1sdovNfN3dW1hmnaEDwuJKwxGdo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
