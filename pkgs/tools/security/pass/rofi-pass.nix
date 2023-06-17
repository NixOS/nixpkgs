{ lib, stdenv, fetchFromGitHub, pass, rofi, coreutils, util-linux, xdotool, gnugrep
, libnotify, pwgen, findutils, gawk, gnused, xclip, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "rofi-pass";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "rofi-pass";
    rev = version;
    sha256 = "131jpcwyyzgzjn9lx4k1zn95pd68pjw4i41jfzcp9z9fnazyln5n";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a config.example $out/share/doc/rofi-pass/config.example
  '';

  wrapperPath = with lib; makeBinPath [
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    libnotify
    (pass.withExtensions (ext: [ ext.pass-otp ]))
    pwgen
    rofi
    util-linux
    xclip
    xdotool
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-pass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A script to make rofi work with password-store";
    homepage = "https://github.com/carnager/rofi-pass";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
  };
}
