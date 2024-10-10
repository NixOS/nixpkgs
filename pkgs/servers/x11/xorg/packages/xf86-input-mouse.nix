{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-mouse";
  version = "1.9.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-mouse";
    rev = "refs/tags/xf86-input-mouse-1.9.5";
    hash = "sha256-vxdzLn9sclIYmPKw7vRa4oQJYmQV98WMfIjkMRosr/w=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
