{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-sun-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "sun-misc";
    rev = "refs/tags/font-sun-misc-1.0.4";
    hash = "sha256-NHWGtIne27VgQ0bjudCD+YubSLnB9WUIgFPHxsUoG3o=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
