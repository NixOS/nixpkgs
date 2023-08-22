{ lib, stdenv, fetchFromGitHub, rofi, systemd, coreutils, util-linux, gawk, makeWrapper, jq
}:

stdenv.mkDerivation rec {
  pname = "rofi-systemd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "rofi-systemd";
    rev = "v${version}";
    sha256 = "sha256-ikwIc8vR2VV3bHXEtLrGgKklpz1NSRUJoJny0iRNViQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-systemd $out/bin/rofi-systemd
  '';

  wrapperPath = with lib; makeBinPath [
    coreutils
    gawk
    jq
    rofi
    systemd
    util-linux
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-systemd --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Control your systemd units using rofi";
    homepage = "https://github.com/IvanMalison/rofi-systemd";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
  };
}
