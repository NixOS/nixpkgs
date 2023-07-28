{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "gog-downloader";
  version = "1.2.3";
  hash = "0kv09vmrz6dcjvaf2sw89cpb14wdr01r1kkzg84szfxwzr5bcc9p";
in
stdenv.mkDerivation {
  inherit pname version hash;

  src = fetchurl {
    url = "https://github.com/RikudouSage/GogDownloader/releases/download/v${version}/gog-downloader";
    sha256 = hash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/share/gog-downloader
    makeWrapper ${php}/bin/php $out/bin/gog-downloader --add-flags "$out/share/gog-downloader"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/RikudouSage/GogDownloader/releases/tag/v${version}";
    description = "GOG games downloader";
    longDescription = ''
      GOG downloader is a tool for downloading game installers of games
      you own on GOG. Supports various filters and options to fine-tune
      your downloads.
    '';
    license = licenses.mit;
    homepage = "https://github.com/RikudouSage/GogDownloader";
    maintainers = [maintainers.rikudou];
  };
}
