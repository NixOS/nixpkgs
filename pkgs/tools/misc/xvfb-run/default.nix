{ lib, stdenv, fetchurl, makeWrapper, xorgserver, getopt
, xauth, util-linux, which, fontsConf, gawk, coreutils }:
let
  xvfb_run = fetchurl {
    name = "xvfb-run";
    # https://git.archlinux.org/svntogit/packages.git/?h=packages/xorg-server
    url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/xvfb-run?h=packages/xorg-server&id=9cb733cefa92af3fca608fb051d5251160c9bbff";
    sha256 = "1307mz4nr8ga3qz73i8hbcdphky75rq8lrvfk2zm4kmv6pkbk611";
  };
in
stdenv.mkDerivation {
  name = "xvfb-run";
  buildInputs = [makeWrapper];
  buildCommand = ''
    mkdir -p $out/bin
    cp ${xvfb_run} $out/bin/xvfb-run

    chmod a+x $out/bin/xvfb-run
    patchShebangs $out/bin/xvfb-run
    wrapProgram $out/bin/xvfb-run \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix PATH : ${lib.makeBinPath [ getopt xorgserver xauth which util-linux gawk coreutils ]}
  '';

  meta = with lib; {
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
