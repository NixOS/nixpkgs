{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-ark";
  version = "0.7.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-ark";
    rev = "refs/tags/xf86-video-ark-0.7.6";
    hash = "sha256-IE35hEZVsfxjwrNxV/xtw8bdox9pwlO/Ra8vkcK19pM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
