{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.18.7";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    sha256 = "171x4pixmh5ni89iawdjl1fk9gr10bgp5bnslpskhspcqzyl1y5b";
  };

  vendorSha256 = "01c2vbnafhhm345nyfmvbvj5mga6laf9w46lhh0flq6kdgdw168s";

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
