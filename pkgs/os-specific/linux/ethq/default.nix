{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "ethq";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "ethq";
    rev = "refs/tags/v${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-luvvNdH4kERAMy242kLCqlnGmfPjSjvoHa6J2J7BFi4=";
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
    homepage = "https://github.com/isc-projects/ethq";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
