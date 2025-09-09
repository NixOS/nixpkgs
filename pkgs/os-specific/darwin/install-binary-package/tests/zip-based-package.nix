{
  fetchzip,
  lib,
  darwin,
}:
darwin.installBinaryPackage rec {
  pname = "Simple-Comic";
  version = "1.9.9";
  src = fetchzip {
    url = "https://github.com/MaddTheSane/Simple-Comic/releases/download/App-Store-${version}/Simple.Comic.${version}.zip";
    hash = "sha256-TCNTb8elcrKPEkr7WeuUBgMZ5EUyIKc1v++M81Hz5IA=";
    stripRoot = false;
  };

  sourceRoot = "";
  appName = "Simple Comic.app";

  meta = with lib; {
    description = "macOS comic viewer";
    longDescription = ''
      Simple Comic is a streamlined comic viewer for macOS.
    '';
    homepage = "https://github.com/MaddTheSane/Simple-Comic/";
    downloadPage = "${meta.homepage}/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ dwt ];
  };
}
