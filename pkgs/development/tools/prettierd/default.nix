{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
}:
mkYarnPackage rec {
  pname = "prettierd";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M9VA67Ix2aKS5V0cA0cFPXkASoAyFxW6rEopSYXtyiA=";
  };

  packageJSON = "${src}/package.json";
  yarnLock = "${src}/yarn.lock";

  buildPhase = ''
    yarn build
  '';

  distPhase = "true";

  meta = with lib; {
    mainProgram = "prettier";
    description = "prettier, as a daemon, for improved formatting speed.";
    homepage = "https://github.com/fsouza/prettierd";
    license = licenses.isc;
    maintainers = with maintainers; [NotAShelf n3oney];
  };
}
