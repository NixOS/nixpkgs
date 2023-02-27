{ lib, stdenv, fetchurl }:

let versions = lib.importJSON ./versions.json;
    arch = if stdenv.isi686 then "386"
           else if stdenv.isx86_64 then "amd64"
           else if stdenv.isAarch32 then "arm"
           else if stdenv.isAarch64 then "arm64"
           else throw "Unsupported architecture";
    os = if stdenv.isLinux then "linux"
         else if stdenv.isDarwin then "darwin"
         else throw "Unsupported os";
    versionInfo = versions."${os}-${arch}";
    inherit (versionInfo) version sha256 url;

in
stdenv.mkDerivation {
  pname = "ngrok";
  inherit version;

  # run ./update
  src = fetchurl { inherit sha256 url; };

  sourceRoot = ".";

  unpackPhase = "cp $src ngrok";

  buildPhase = "chmod a+x ngrok";

  installPhase = ''
    install -D ngrok $out/bin/ngrok
  '';

  passthru.updateScript = ./update.sh;

  # Stripping causes SEGFAULT on x86_64-darwin
  dontStrip = true;

  meta = with lib; {
    description = "Allows you to expose a web server running on your local machine to the internet";
    homepage = "https://ngrok.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ bobvanderlinden brodes ];
  };
}
