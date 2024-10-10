{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-ati";
  version = "1.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-ati";
    rev = "5eba006e4129e8015b822f9e1d2f1e613e252cda";
    hash = "sha256-dlJi2YUK/9qrkwfAy4Uds4Z4a82v6xP2RlCOsEHnidg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
