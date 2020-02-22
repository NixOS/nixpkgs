{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  name = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = "2.0.14";

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "0hyy9fki2626cgd78l7fkk67lik6g1pkcpf6xr3gl07dxwcclyr8";
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
