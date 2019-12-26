{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  name = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = "2.0.12";

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "0pkws83ymmlxcdxadb1w6rmibw84vzhx9xrhxc6b1rjncb80l0kk";
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
