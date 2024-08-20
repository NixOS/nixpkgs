{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cliphist";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U78G7X9x3GQg3qcBINni8jWa0wSXQu+TjYChuRPPcLE=";
  };

  vendorHash = "sha256-O4jOFWygmFxm8ydOq1xtB1DESyWpFGXeSp8a6tT+too=";

  postInstall = ''
    cp ${src}/contrib/* $out/bin/
  '';

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "cliphist";
  };
}
