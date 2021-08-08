{ lib, buildFishPlugin, fetchFromGitHub, fishtape }:

buildFishPlugin rec {
  pname = "done";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    sha256 = "Xld66z9vVp3kxikndZ9k/zlNvP0YSoSCNTBkJ8rT3uo=";
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
