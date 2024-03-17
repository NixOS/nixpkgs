{ lib, fetchurl, darwin }:

darwin.installBinaryPackage rec {
  pname = "apparency";
  version = "1.8.1";

  src = fetchurl {
    # Use externally archived download URL because
    # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/20240304101835/https://www.mothersruin.com/software/downloads/Apparency.dmg";
    hash = "sha256-hxbAtIy7RdhDrsFIvm9CEr04uUTbWi4KmrzJIcU1YVA=";
  };

  appName = "Apparency.app";
  sourceRoot = "Apparency ${version}";

  postInstall = ''
    mkdir -p $out/bin
    ln -s ../Applications/${appName}/Contents/MacOS/${meta.mainProgram} $out/bin
  '';

  meta = {
    description = "The App That Opens Apps";
    homepage = "https://www.mothersruin.com/software/Apparency/";
    downloadPage = "https://www.mothersruin.com/software/Apparency/get.html";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "appy";
  };
}
