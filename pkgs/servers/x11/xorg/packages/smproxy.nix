{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smproxy";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "smproxy";
    rev = "refs/tags/smproxy-1.0.7";
    hash = "sha256-w+TCTJqOWVk6ex9QRQLk1vKns3bO3t2knx9jv24lZdc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
