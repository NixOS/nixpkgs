{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-type1";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-type1";
    rev = "refs/tags/font-bh-type1-1.0.4";
    hash = "sha256-u0VDg8rSZKkNZgjf4Lp3i5N3JPDXW9G37wdOtusT1Sk=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
