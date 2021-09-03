{ lib, stdenv, fetchurl, makeWrapper, xorgserver, getopt
, xauth, util-linux, which, fontsConf, gawk, coreutils }:
let
  xvfb-run = fetchurl {
    name = "xvfb-run";
    url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/9cb733cefa92af3fca608fb051d5251160c9bbff/trunk/xvfb-run";
    sha256 = "1307mz4nr8ga3qz73i8hbcdphky75rq8lrvfk2zm4kmv6pkbk611";
  };
in
stdenv.mkDerivation {
  name = "xvfb-run";
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    cp ${xvfb-run} $out/bin/xvfb-run

    chmod a+x $out/bin/xvfb-run
    patchShebangs $out/bin/xvfb-run
    wrapProgram $out/bin/xvfb-run \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix PATH : ${lib.makeBinPath [ getopt xorgserver xauth which util-linux gawk coreutils ]}
  '';

  meta = with lib; {
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
