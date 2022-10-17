{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "paperlike-go";
  version = "unstable-2021-03-26";

  src = fetchFromGitHub {
    owner = "leoluk";
    repo = "paperlike-go";
    rev = "bd658d88ea9a3b21e1b301b96253abab7cf56d79";
    sha256 = "1h0n2n5w5pn3r08qf6hbmiib5m71br27y66ki9ajnaa890377qaj";
  };

  subPackages = [ "cmd/paperlike-cli" ];

  vendorSha256 = "00mn0zfivxp2h77s7gmyyjp8p5a1vysn73wwaalgajymvljxxx1r";

  meta = {
    description = "paperlike-go is a Linux Go library and CLI utility to control a Dasung Paperlike display via I2C DDC.";
    homepage = "https://github.com/leoluk/paperlike-go";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.linux;
  };
}
