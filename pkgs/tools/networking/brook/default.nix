{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "brook";
  version = "20240606";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rfCqYI0T/nbK+rlPGl5orLo3qHKITesdFNtXc/ECATA=";
  };

  vendorHash = "sha256-dYiifLUOq6RKAVSXuoGlok9Jp8jHmbXN/EjQeQpoqWw=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "brook";
  };
}
