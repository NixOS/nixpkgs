{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "packer";
  version = "1.6.2";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "0kr9whv3s0f8866yjmwg311j3kcj29bp5xwpnv43ama4m1mq3bm7";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    platforms   = platforms.unix;
  };
}
