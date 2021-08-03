{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  pname = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = import ./version.nix;

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = import ./source-sha.nix;
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
