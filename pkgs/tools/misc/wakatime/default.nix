{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.61.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "sha256-pd6kK1591dLEau9oKdd+A2y8rRerFQ+z2yY+/BsNUAI=";
  };

  vendorHash = "sha256-R+VqIw8fztBH2WTf5vjqtMfASNnOTjA3DEndXYyyMi4=";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "WakaTime command line interface";
    longDescription = ''
      Command line interface to WakaTime used by all WakaTime text editor
      plugins. You shouldn't need to directly use this package unless you
      are building your own plugin or your text editor's plugin asks you
      to install the wakatime CLI interface manually.
    '';
    license = licenses.bsd3;
    mainProgram = "wakatime-cli";
  };
}
