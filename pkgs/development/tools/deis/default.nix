{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "deis-${version}";
  version = "1.13.0";
  rev = "v${version}";
  
  goPackagePath = "github.com/deis/deis";
  subPackages = [ "client" ];

  postInstall = ''
    if [ -f "$bin/bin/client" ]; then
      mv "$bin/bin/client" "$bin/bin/deis"
    fi
  '';

  src = fetchFromGitHub {
    inherit rev;
    owner = "deis";
    repo = "deis";
    sha256 = "1qv9lxqx7m18029lj8cw3k7jngvxs4iciwrypdy0gd2nnghc68sw";
  };

  goDeps = ./deps.json;
}
