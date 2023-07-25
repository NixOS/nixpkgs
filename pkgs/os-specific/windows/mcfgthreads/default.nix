{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "mcfgthreads";
  version = "unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    rev = "f0a335ce926906d634c787249a89220045bf0f7e";
    hash = "sha256-PLGIyoLdWgWvkHgRe0vHLIvnCxFpmHtbjS8xRhNM9Xw=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoreconfHook
  ];
}
