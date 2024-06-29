{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "ethq";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "ethq";
    rev = "refs/tags/v${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-ye5ep9EM9Sq/NqNZHENPmFZefVBx1BGrPm3YEG1NcSc=";
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
