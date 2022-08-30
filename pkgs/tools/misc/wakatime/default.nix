{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "sha256-HjhicBNkpyKb2GX4J3crhp2JgRGqmkQPUZe8rHrQG/g=";
  };

  vendorSha256 = "sha256-8QMrfCq5oAS+fjUccBeGrEGU5y4vtZr2o2HhpDk90K0=";

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
