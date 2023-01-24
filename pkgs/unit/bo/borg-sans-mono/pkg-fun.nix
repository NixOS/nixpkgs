# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  pname = "borg-sans-mono";
  version = "0.2.0";
in
(fetchzip {
  name = "${pname}-${version}";

  # https://github.com/marnen/borg-sans-mono/issues/19
  url = "https://github.com/marnen/borg-sans-mono/files/107663/BorgSansMono.ttf.zip";
  sha256 = "1gz4ab0smw76ih5cs2l3n92c77nv7ld5zghq42avjsfhxrc2n5ri";

  meta = with lib; {
    description = "Droid Sans Mono Slashed + Hasklig-style ligatures";
    homepage = "https://github.com/marnen/borg-sans-mono";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ atila ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';
})
