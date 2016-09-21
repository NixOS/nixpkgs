{ stdenv, fetchurl
, pass, rofi, coreutils, utillinux, xdotool, gnugrep, pwgen, findutils, gawk
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/carnager/rofi-pass/archive/${version}.tar.gz";
    sha256 = "02z1w7wnmg0ymajxanl7z7fxl1w6by4r9w56zd10yr2zzbw7zcm7";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a config.example $out/share/doc/rofi-pass/config.example
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
    coreutils
    findutils
    gnugrep
    pass
    pwgen
    rofi
    utillinux
    xdotool
    gawk
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-pass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A script to make rofi work with password-store";
    homepage = https://github.com/carnager/rofi-pass;
    maintainers = with stdenv.lib.maintainers; [ hiberno the-kenny ];
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; linux;
  };
}
