# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "3.003";
in (fetchzip {
  name = "hack-font-${version}";

  url = "https://github.com/chrissimpkins/Hack/releases/download/v${version}/Hack-v${version}-ttf.zip";

  sha256 = "1l6ih6v7dqali5c7zh6z2xnbf9h2wz0ag6fdgszmqd5lnhw39v6s";

  meta = with lib; {
    description = "A typeface designed for source code";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.
    '';
    homepage = "https://sourcefoundry.org/hack/";

    /*
     "The font binaries are released under a license that permits unlimited
      print, desktop, and web use for commercial and non-commercial
      applications. It may be embedded and distributed in documents and
      applications. The source is released in the widely supported UFO format
      and may be modified to derive new typeface branches. The full text of
      the license is available in LICENSE.md" (From the GitHub page)
    */
    license = licenses.free;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/hack
  '';
})
