{
  replaceVars,
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
}:

buildGoModule rec {
  pname = "keybase";
  version = "6.5.1";

  modRoot = "go";
  subPackages = [
    "kbnm"
    "keybase"
  ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    hash = "sha256-B3vedsxQM4FDZVpkMKR67DF7FtaTPhGIJ1e2lViKYzg=";
  };
  vendorHash = "sha256-uw1tiaYoMpMXCYt5bPL5OBbK09PJmAQYQDrDwuPShxU=";

  patches = [
    (replaceVars ./fix-paths-keybase.patch {
      gpg = "${gnupg}/bin/gpg";
      gpg2 = "${gnupg}/bin/gpg2";
    })
  ];
  tags = [ "production" ];
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://www.keybase.io/";
    description = "Keybase official command-line utility and service";
    mainProgram = "keybase";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      avaq
      np
      rvolosatovs
      shofius
      ryand56
    ];
    license = lib.licenses.bsd3;
  };
}
