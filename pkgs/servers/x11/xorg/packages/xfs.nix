{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfs";
  version = "1.2.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xfs";
    rev = "refs/tags/xfs-1.2.1";
    hash = "sha256-bV9shoR5c+AbPrthAyrQDB6d2PJZdwxPTe2vC9anWKM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
