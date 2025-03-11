{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfsinfo";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xfsinfo";
    rev = "refs/tags/xfsinfo-1.0.7";
    hash = "sha256-wzU3qkAKcR0cyA7cSXTLbvFOoXtRnItNVTMd3ok7lwI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
