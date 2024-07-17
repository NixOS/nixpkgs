{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "paperlike-go";
  version = "unstable-2021-03-26";

  src = fetchFromGitHub {
    owner = "leoluk";
    repo = "paperlike-go";
    rev = "bd658d88ea9a3b21e1b301b96253abab7cf56d79";
    hash = "sha256-UuFzBkhIKStVitMYf0Re4dSyYqwLGocRyMPewosVFsA=";
  };

  vendorHash = "sha256-OfTeJd3VS/WoUpyPY7XfQZWLrvS+vqPPgeL2Hd0HtgI=";

  subPackages = [ "cmd/paperlike-cli" ];

  meta = {
    description = "A Linux Go library and CLI utility to control a Dasung Paperlike display via I2C DDC";
    homepage = "https://github.com/leoluk/paperlike-go";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.linux;
    mainProgram = "paperlike-cli";
  };
}
