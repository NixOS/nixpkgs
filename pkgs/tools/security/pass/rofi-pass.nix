{ stdenv, fetchgit
, pass, rofi, coreutils, utillinux, xdotool, gnugrep, pwgen, findutils
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "1.3.1";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "refs/tags/${version}";
    sha256 = "1r206fq96avhlgkf2fzf8j2a25dav0s945qv66hwvqwhxq74frrv";
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
  };
}
