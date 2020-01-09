{ yarn2nix-moretea
, fetchFromGitHub
}:

yarn2nix-moretea.mkYarnPackage rec {
  name = "gotify-ui";

  packageJSON = ./package.json;
  yarnNix = ./yarndeps.nix;

  version = "2.0.13";

  src_all = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "11ycs1ci1z8wm4fjgk4454kgszr4s8q9dc96pl77yvlngi4dk46d";
  };
  src = "${src_all}/ui";

  buildPhase = ''
    yarn build
  '';

}
