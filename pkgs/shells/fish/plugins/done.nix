{ lib, buildFishPlugin, fetchFromGitHub, fishtape }:

buildFishPlugin rec {
  pname = "done";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-aYKTkx5v7tB6k/UBcS0NOgA6SiRrjzn1lUTH/Xp5DFM=";
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
