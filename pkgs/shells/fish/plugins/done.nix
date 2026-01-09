{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:

buildFishPlugin rec {
  pname = "done";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-GZ1ZpcaEfbcex6XvxOFJDJqoD9C5out0W4bkkn768r0=";
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

  meta = {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
  };
}
