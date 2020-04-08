{ lib, buildGoPackage, fetchFromGitHub, pkg-config, libusb1 }:

buildGoPackage rec {
  pname = "wally-cli";
  version = "1.1.1";

  goPackagePath = "github.com/zsa/wally";
  subPackages = [ "cli" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "68960e452ee0f6c7142f5008d4b1cdc6284d3de7";
    sha256 = "122m5v7s5wqlshyk2salmd848lqs4rrz54d2ap11ay61kijm0bs2";
  };

  postInstall = ''
    mv $bin/bin/cli $bin/bin/wally
  '';

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A tool to flash firmware to mechanical keyboards";
    homepage = https://ergodox-ez.com/pages/wally-planck;
    license = licenses.mit;
    maintainers = [ maintainers.spacekookie ];
  };
}
