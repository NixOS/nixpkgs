{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "fishtape";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fishtape";
    rev = version;
    sha256 = "0dxcyhs2shhgy5xnwcimqja8vqsyk841x486lgq13i3y1h0kp2kd";
  };

  checkFunctionDirs = [ "./" ]; # fishtape is introspective
  checkPhase = ''
    rm test/tty.fish  # test expects a tty
    fishtape test/*.fish
  '';

  preInstall = ''
    # move the function script in the proper sub-directory
    mkdir functions
    mv fishtape.fish functions/
  '';

  meta = {
    description = "TAP-based test runner for Fish";
    homepage = "https://github.com/jorgebucaran/fishtape";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
