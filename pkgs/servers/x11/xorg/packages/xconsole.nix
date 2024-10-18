{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xconsole";
  version = "1.0.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xconsole";
    rev = "refs/tags/xconsole-1.0.8";
    hash = "sha256-wlY5OBOQ0AT9+EGGUv4VWWHuZSsF0sbrGYdpk8VbtTM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
