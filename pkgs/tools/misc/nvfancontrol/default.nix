{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libXNVCtrl,
  libx11,
  libxext,
}:

rustPlatform.buildRustPackage rec {
  pname = "nvfancontrol";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "foucault";
    repo = pname;
    rev = version;
    sha256 = "sha256-0WBQSnTYVc3sNmZf/KFzznMg9AVsyaBgdx/IvG1dZAw=";
  };

  cargoHash = "sha256-nJc1G9R0+o22H1KiBtzfdcIIfKrD+Dksl7HsZ2ICD7U=";

  nativeBuildInputs = [
    libXNVCtrl
    libx11
    libxext
  ];

  # Needed for static linking
  preConfigure = ''
    export LIBRARY_PATH=${libXNVCtrl}/lib:${libx11}/lib:${libxext}/lib
  '';

  meta = {
    description = "Nvidia dynamic fan control for Linux";
    homepage = "https://github.com/foucault/nvfancontrol";
    changelog = "https://github.com/foucault/nvfancontrol/releases/tag/${version}";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ devins2518 ];
    mainProgram = "nvfancontrol";
  };
}
