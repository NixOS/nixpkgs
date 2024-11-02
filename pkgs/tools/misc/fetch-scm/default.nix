{ lib, stdenv, fetchFromGitHub, guile }:

stdenv.mkDerivation rec {
  pname = "fetch-scm";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "KikyTokamuro";
    repo = "fetch.scm";
    rev = "v${version}";
    sha256 = "sha256-WdYi8EVxQ6xPtld8JyZlUmgpxroevBehtkRANovMh2E=";
  };

  dontBuild = true;

  buildInputs = [ guile ];

  installPhase = ''
    runHook preInstall
    install -Dm555 fetch.scm $out/bin/fetch-scm
    runHook postInstall
  '';

  meta = with lib; {
    description = "System information fetcher written in GNU Guile Scheme";
    homepage = "https://github.com/KikyTokamuro/fetch.scm";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vel ];
    mainProgram = "fetch-scm";
  };
}
