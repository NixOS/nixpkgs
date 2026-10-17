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
    hash = "sha256-bYo7AQx+xBHwowaRHgiaXuONlMQ1Mm578Q9CLTT0rDc=";
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
