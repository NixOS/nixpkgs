{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-sisusb";
  version = "0.9.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sisusb";
    rev = "refs/tags/xf86-video-sisusb-0.9.7";
    hash = "sha256-Z4q1ChH+u5u+NOsrwTnBVF2iJbvkd/stffdCRK73DS8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
