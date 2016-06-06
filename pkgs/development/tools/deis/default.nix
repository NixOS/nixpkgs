{ stdenv, lib, buildGoPackage, fetchgit }:

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

  src = fetchgit {
    inherit rev;
    url = "https://github.com/deis/deis";
    sha256 = "1fblg3gf7dh5hhm4ajq7yl7iy6gw8p5xlh4z8kvfy542m1fzr0dc";
  };

  goDeps = ./deps.json;
}
