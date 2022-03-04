{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "sha256-1JOsE8u4+LlWL9nU/fXIqVME1VsgxZV84lJXNTY2pZg=";
  };

  vendorSha256 = "sha256-WKay4/bsy8jCOTQ2jHQPMBNfIuTI3QzdmhG1aOHNK0Y=";

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
  };
}
