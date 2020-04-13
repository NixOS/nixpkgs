{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "packer";
  version = "1.5.5";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "1l5n6s4fg6rgb7k845hsxgrs44y9bs2hmdxqzfbayiv8nz1qg286";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
