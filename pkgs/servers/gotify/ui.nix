{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  name = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = "2.0.11";

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "0zrylyaxy1cks1wlzyf0di8in2braj4pfriyqa24vipwrlnhvgs6";
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
