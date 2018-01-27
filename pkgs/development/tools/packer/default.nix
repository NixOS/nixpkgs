{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "1.1.3";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "0bfjv4sqci10jzy11qg6q1xyik36v98vd6ck91sarawvgbaprsp2";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = https://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
