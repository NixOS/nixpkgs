{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxshmfence";
  version = "1.3.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxshmfence";
    rev = "refs/tags/libxshmfence-1.3.2";
    hash = "sha256-de08vW20sS725RAfqSGh8LM9vEeB5bpAxLAcMsQWc+4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
