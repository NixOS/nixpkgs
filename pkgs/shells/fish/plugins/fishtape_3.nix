{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "fishtape";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fishtape";
    rev = version;
    hash = "sha256-Sp2IarJe2SVBH1pD7pdDnXrndG4h3b5G4f3SMBceShw=";
  };

  checkFunctionDirs = [ "./functions" ]; # fishtape is introspective
  checkPhase = ''
    fishtape tests/*.fish
  '';

  meta = {
    description = "100% pure-Fish test runner";
    homepage = "https://github.com/jorgebucaran/fishtape";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
