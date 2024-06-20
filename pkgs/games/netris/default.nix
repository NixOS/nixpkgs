{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation {
  pname = "netris";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "naclander";
    repo = "netris";
    rev = "6773c9b2d39a70481a5d6eb5368e9ced6229ad2b";
    sha256 = "0gmxbpn50pnffidwjchkzph9rh2jm4wfq7hj8msp5vhdq5h0z9hm";
  };

  buildInputs = [
    ncurses
  ];

  configureScript = "./Configure";
  dontAddPrefix = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ./netris $out/bin
  '';

  meta = with lib; {
    description = "Free networked version of T*tris";
    mainProgram = "netris";
    license = licenses.gpl2;
    maintainers = with maintainers; [ patryk27 ];
    platforms = platforms.linux;
  };
}
