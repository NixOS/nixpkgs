{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "ethq";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "ethq";
    rev = "refs/tags/v${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-dr37KiSnP0S0OjQof242EcbH+y4pCCzu6R9D6fXR9qc=";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m0755 ethq $out/bin/ethq

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ethernet NIC Queue stats viewer";
    mainProgram = "ethq";
    homepage = "https://github.com/isc-projects/ethq";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
