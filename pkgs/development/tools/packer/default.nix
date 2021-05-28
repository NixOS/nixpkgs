{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "packer";
  version = "1.6.4";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "0nkbm5iamkzi5x64107apnwmqxs4a75pxw935pwpm69ry4535r7w";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    platforms   = platforms.unix;
  };
}
