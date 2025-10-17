{
  fetchurl,
  lib,
  darwin,
}:
darwin.installBinaryPackage rec {
  pname = "iChm";
  version = "1.5.2";
  src = fetchurl {
    url = "https://github.com/vit9696/iChm/releases/download/1.5.2/iChm-${version}-RELEASE.dmg";
    hash = "sha256-JjDQXwhfJDJOtnIBMa9zg1jdAeqeUAuwFoY1LGeflvA=";
  };

  sourceRoot = "iChm";
  appName = "iChm.app";

  meta = with lib; {
    description = "CHM reader for macOS";
    longDescription = ''
      iChm is a chm (Compiled HTML Help) file reader for macOS 10.9 and newer.
    '';
    homepage = "https://github.com/vit9696/iChm";
    downloadPage = "https://github.com/vit9696/iChm/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dwt ];
  };
}
