{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "sha256-3xeTkODG6CMDFjUrh89cFi9UlTikmWmxM3P3vg2pXEo=";
  };

  vendorSha256 = "sha256-ANRcgeZYtcWGbK8c9KE8joo97d8LKvKA8/A+/rrjOoM=";

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
