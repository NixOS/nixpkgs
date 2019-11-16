{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  name = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = "2.0.8";

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "17bxs3wcazrxippf3i9w7d2mq8lf0v5m4bn3nl2zb8v8dl3lsc9a";
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
