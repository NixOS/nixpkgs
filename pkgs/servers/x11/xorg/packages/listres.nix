{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listres";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "listres";
    rev = "refs/tags/listres-1.0.5";
    hash = "sha256-6+n3iOPWWJZQbK7TOJW5uOjE6SawNFxus5y8XI4ZL08=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
