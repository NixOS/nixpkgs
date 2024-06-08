{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "gpp";
  version = "2.25";

  src = fetchFromGitHub {
    owner = "logological";
    repo = "gpp";
    rev = "96c5dd8905384ea188f380f51d24cbd7fd58f642";
    sha256 = "0bvhnx3yfhbfiqqhhz6k2a596ls5rval7ykbp3jl5b6062xj861b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  installCheckPhase = "$out/bin/gpp --help";
  doInstallCheck = true;

  meta = with lib; {
    description = "General-purpose preprocessor with customizable syntax";
    mainProgram = "gpp";
    homepage = "https://logological.org/gpp";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nmattia ];
    platforms = with platforms; linux ++ darwin;
  };
}
