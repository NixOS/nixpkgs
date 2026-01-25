{
  autoreconfHook,
  fetchgit,
  lib,
  stdenv,
  w32api-headers,
}:

stdenv.mkDerivation rec {
  pname = "rebase";
  version = "4.6.6";

  src = fetchgit {
    url = "https://cygwin.com/git/cygwin-apps/rebase.git";
    rev = "${pname}-${version}";
    hash = "sha256-mZNPjgIwkUPOBZvMMVeVTXqJRu/sXVoZshm9Q1oa2u0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];
}
