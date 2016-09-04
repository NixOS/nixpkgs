{ stdenv, fetchgit
, pass, rofi, coreutils, utillinux, xdotool, gnugrep, pwgen, findutils, gawk
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "1.3.2";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "refs/tags/${version}";
    sha256 = "1xqp8s0yyjs2ca9mf8lbz8viwl9xzxf5kk1v68v9hqdgxj26wgls";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a $src/rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a $src/config.example $out/share/doc/rofi-pass/config.example
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
