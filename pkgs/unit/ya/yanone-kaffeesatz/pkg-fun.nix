# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

(fetchzip {
  name = "yanone-kaffeesatz-2004";

  url = "https://yanone.de/2015/data/UIdownloads/Yanone%20Kaffeesatz.zip";

  sha256 = "190c4wx7avy3kp98lsyml7kc0jw7csf5n79af2ypbkhsadfsy8di";

  meta = {
    description = "The free font classic";
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = with lib.platforms; all;
    homepage = "https://yanone.de/fonts/kaffeesatz/";
    license = lib.licenses.ofl;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
})
