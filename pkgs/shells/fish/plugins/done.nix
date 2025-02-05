{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:

buildFishPlugin rec {
  pname = "done";
  version = "1.19.3";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
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
