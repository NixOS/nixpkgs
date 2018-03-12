{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "1.2.0";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "05qsyh6d4qsvabr543ggd4b09fipxzr270cawsx0glmkgw82nkzi";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = https://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
