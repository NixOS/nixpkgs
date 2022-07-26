{ lib, buildFishPlugin, fetchFromGitHub, fishtape }:

buildFishPlugin rec {
  pname = "done";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    sha256 = "E0wveeDw1VzEH2kzn63q9hy1xkccfxQHBV2gVpu2IdQ=";
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

  meta = {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malo ];
  };
}
