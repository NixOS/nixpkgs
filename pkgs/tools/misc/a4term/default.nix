{ lib
, stdenv
, fetchFromGitHub
, libtickit
, libvterm-neovim
}:

stdenv.mkDerivation rec {
  pname = "a4term";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "rpmohn";
    repo = "a4";
    rev = "v${version}";
    hash = "sha256-hsAEiPOZBqjvmSZEmZwfDqHZV/8ym62RZPxl3DG4ntQ=";
  };

  buildInputs = [
    libtickit
    libvterm-neovim
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A dynamic terminal window manager";
    homepage = "https://www.a4term.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza ];
    platforms = lib.platforms.linux;
    mainProgram = "a4";
  };
}
