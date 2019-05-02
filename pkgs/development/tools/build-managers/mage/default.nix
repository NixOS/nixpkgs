{ buildGoPackage, fetchFromGitHub, lib }:

with lib;

buildGoPackage rec {
  name = "mage-${version}";
  version = "1.7.1";

  goPackagePath = "github.com/magefile/mage";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "magefile";
    repo = "mage";
    rev = "v${version}";
    sha256 = "0n4k5dy338rxwzj654smxzlanmd0zws6mdzv0wc4byqjhr7mqhg2";
  };

  buildFlagsArray = [ 
    "-ldflags="
    "-X github.com/magefile/mage/mage.commitHash=v${version}"
    "-X github.com/magefile/mage/mage.gitTag=v${version}"
  ];

  meta = {
    description = "A Make/Rake-like Build Tool Using Go";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://magefile.org/;
    platforms = platforms.all;
  };
}
