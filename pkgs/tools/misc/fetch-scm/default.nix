{ lib, stdenv, fetchFromGitHub, guile }:

stdenv.mkDerivation rec {
  pname = "fetch-scm";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "KikyTokamuro";
    repo = "fetch.scm";
    rev = "v${version}";
    sha256 = "sha256-H89VCNAYnTwVEqyInATvLHIB7ioe2zvIGTAM2MUo7+g=";
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
  };
}
