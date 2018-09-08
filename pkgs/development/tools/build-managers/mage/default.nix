{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  name = "mage-${version}";
  version = "1.2.4";
  rev = "v${version}";

  goPackagePath = "github.com/magefile/mage";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "magefile";
    repo = "mage";
    sha256 = "1870pgxsbhj54z8ks26pzidzsr2mfl1g226gw9j6s3xjdbbslylk";
  };
  
  # ex: from pkgs/development/tools/dep/default.nix
  # buildFlagsArray = ("-ldflags=-s -w -X main.commitHash=${rev} -X main.version=${version}");
  buildFlagsArray = ("-ldflags=-X github.com/magefile/mage/mage.gitTag=${rev}");

  meta = {
    description = "A Make/Rake-like Build Tool Using Go";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://magefile.org/;
    platforms = platforms.all;
  };
}
