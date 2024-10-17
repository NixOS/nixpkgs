{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-vmware";
  version = "13.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-vmware";
    rev = "refs/tags/xf86-video-vmware-13.4.0";
    hash = "sha256-aC/LsAvrVtG+2SrMaB7ROJTUIleZTcLydmt5cQf0dHc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
