{ stdenv, fetchurl, makeWrapper, xkbcomp, xorgserver, getopt, xkeyboard_config
, xauth, utillinux, which, fontsConf, gawk, coreutils }:
let
  xvfb_run = fetchurl {
    url = https://projects.archlinux.org/svntogit/packages.git/plain/trunk/xvfb-run?h=packages/xorg-server;
    sha256 = "1f9mrhqy0l72i3674n98bqlq9a10h0rh9qfjiwvivz3hjhq5c0gz";
  };
in
stdenv.mkDerivation {
  name = "xvfb-run";
  buildInputs = [makeWrapper];
  buildCommand = ''
    mkdir -p $out/bin
    cp ${xvfb_run} $out/bin/xvfb-run
    sed -i 's|XVFBARGS="|XVFBARGS="-xkbdir ${xkeyboard_config}/etc/X11/xkb |' $out/bin/xvfb-run

    chmod a+x $out/bin/xvfb-run
    wrapProgram $out/bin/xvfb-run \
      --set XKB_BINDIR "${xkbcomp}/bin" \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux gawk coreutils ]}
  '';
}
