{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXvMC";
  version = "1.0.13";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXvMC";
    rev = "refs/tags/libXvMC-1.0.13";
    hash = "sha256-unkMkjZlTdSg/3A6IaWSGt88ZXvZ2hwV6MqBwepQLkE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
