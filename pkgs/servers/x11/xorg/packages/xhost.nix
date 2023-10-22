{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xhost";
  version = "1.0.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xhost";
    rev = "refs/tags/xhost-1.0.9";
    hash = "sha256-jqsPdJ+/Ci5lhg5i4JINxnxKVcri4uT8MV2A0csu64Q=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
