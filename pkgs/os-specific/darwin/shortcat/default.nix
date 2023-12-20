{ lib, fetchzip }:

fetchzip rec {
  pname = "shortcat";
  version = "0.11.0";

  url = "https://files.shortcat.app/releases/v${version}/Shortcat.zip";
  hash = "sha256-lEX+6/2EHKWf4GdsZj6vLRGAxbJUAuge8zCPSc/13rQ=";

  stripRoot = false;

  postFetch = ''
    shopt -s extglob
    mkdir $out/Applications
    mv $out/!(Applications) $out/Applications
  '';

  meta = with lib; {
    description = "Manipulate macOS masterfully, minus the mouse";
    homepage = "https://shortcat.app/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
    maintainers = with maintainers; [ Enzime ];
    license = licenses.unfreeRedistributable;
  };
}
