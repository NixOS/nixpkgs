{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "packer";
  version = "1.4.4";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "00il85qbj5yadm5l5bczv7awmaazn9k3v3i0wsd6dbwpjga6snw9";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = https://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
