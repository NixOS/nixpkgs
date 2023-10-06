{ lib, buildFishPlugin, fetchFromGitHub, fishtape }:

buildFishPlugin rec {
  pname = "done";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-H+PVoZZ0JdGPcQBib600dzaymlU6rPCSEi8VZXyi/Xc=";
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
