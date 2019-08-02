{ stdenv, fetchurl, makeWrapper, xorgserver, getopt
, xauth, utillinux, which, fontsConf, gawk, coreutils }:
let
  xvfb_run = fetchurl {
    name = "xvfb-run";
    # https://git.archlinux.org/svntogit/packages.git/?h=packages/xorg-server
    url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/xvfb-run?h=packages/xorg-server&id=9cb733cefa92af3fca608fb051d5251160c9bbff;
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
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux gawk coreutils ]}
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
