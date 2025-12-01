{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:

buildFishPlugin rec {
  pname = "done";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-GXKchepYti5Pb1ODFeJL3apDGg7Tn69skQQhvV2nSeQ=";
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

  meta = with lib; {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
