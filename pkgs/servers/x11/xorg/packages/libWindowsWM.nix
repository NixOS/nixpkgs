{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libWindowsWM";
  version = "1.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libWindowsWM";
    rev = "refs/tags/libWindowsWM-1.0.1";
    hash = "sha256-Pq6HyFWnhW54PQa4xlJJPw4TvMiaq2HCj7QBxH9/LoM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
