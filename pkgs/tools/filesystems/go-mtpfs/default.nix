{ pkg-config, libusb1, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-mtpfs";
  version = "unstable-2018-02-09";

  goPackagePath = "github.com/hanwen/go-mtpfs";

  src = fetchFromGitHub {
    owner = "hanwen";
    repo = "go-mtpfs";
    rev = "d6f8f3c05ce0ed31435057ec342268a0735863bb";
    sha256 = "sha256-sz+ikhZGwSIAI2YBSQKURF3WXB8dHgQ/C/dbkXwrDSg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  goDeps = ./deps.nix;
}
