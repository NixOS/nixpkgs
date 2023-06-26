{ stdenv, fetchFromGitHub,bash }:
stdenv.mkDerivation rec {
  name = "maxfetch-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "jobcmax";
    repo = "maxfetch";
    rev = "6ef37bc7780221894d6daff118a4866cc846aed8";
    sha256 = "sha256-9rw51wo01N/pKFOZjuX/onHJ0nODwSx5SCabpXE/JFc=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ bash ];

  buildPhase = ''
    chmod +x maxfetch
    sed -i '/uptime/d' maxfetch
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp maxfetch $out/bin
  '';
}
