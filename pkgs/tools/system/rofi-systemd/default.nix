{ stdenv, fetchFromGitHub, rofi, systemd, coreutils, utillinux, gawk, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "rofi-systemd-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "rofi-systemd";
    rev = "v${version}";
    sha256 = "1dbygq3qaj1f73hh3njdnmibq7vi6zbyzdc6c0j989c0r1ksv0zi";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-systemd $out/bin/rofi-systemd
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
    rofi
    coreutils
    utillinux
    gawk
    systemd
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-systemd --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Control your systemd units using rofi";
    homepage = https://github.com/IvanMalison/rofi-systemd;
    maintainers = with stdenv.lib.maintainers; [ imalison ];
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; linux;
  };
}
