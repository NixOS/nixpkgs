{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gccmakedep";
  version = "1.0.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "gccmakedep";
    rev = "refs/tags/gccmakedep-1.0.3";
    hash = "sha256-k7VzCINvJb0al6rrs/c3pMf4YAnYuWiyXmaNoDat4Y8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
