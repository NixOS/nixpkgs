{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.35.4";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "sha256-MG2ROWQh8A7LrdOnDWLG9AsHjzfv84KjmjZXhJlMrLQ=";
  };

  vendorSha256 = "sha256-8FaM83+d1VQ/9le2hD0nqErhH/jOHMxbNz2o4D3qWb8=";

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
