{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-alias";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "alias";
    rev = "refs/tags/font-alias-1.0.5";
    hash = "sha256-qglRNSt/PgFprpsvOVCeLMA+YagJw8DZMAfFdZ0m0/s=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
