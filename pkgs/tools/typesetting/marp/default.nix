{
  mkYarnPackage
, fetchFromGitHub
, lib
}:

let version = "3.1.0";
in
mkYarnPackage {
  name = "marp-cli";
  version = version;
  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${version}";
    sha256 = "2TsiHv598uxbns8CAz5mljSsFU3gFuHaZpBaaE2KMkE=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  buildPhase = ''
    export HOME=$(mktemp -d)
    yarn --offline build
  '';

  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
