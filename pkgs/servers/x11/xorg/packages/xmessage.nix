{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmessage";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xmessage";
    rev = "refs/tags/xmessage-1.0.6";
    hash = "sha256-O8uyvYse4LouOtxiNaA5HtG1Utw9rd1PzCQMXC1855I=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
