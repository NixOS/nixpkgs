{ stdenv, lib, buildPythonApplication, fetchFromGitHub, makeDesktopItem, makeWrapper
, aria
, libnotify
, pulseaudio
, psutil
, pyqt5
, requests
, setproctitle
, sound-theme-freedesktop
, youtube-dl
}:

buildPythonApplication rec {
  pname = "persepolis";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    rev = "${version}";
    sha256 = "0xngk8wgj5k27mh3bcrf2wwzqr8a3g0d4pc5i5vcavnnaj03j44m";
  };

  # see: https://github.com/persepolisdm/persepolis/blob/3.1.0/setup.py#L130
  doCheck = false;

  preBuild=''
    substituteInPlace setup.py --replace "answer = input(" "answer = 'y'#"
  '';

  postPatch = ''
    sed -i 's|/usr/share/sounds/freedesktop/stereo/|${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/|' setup.py
    sed -i "s|'persepolis = persepolis.__main__'|'persepolis = persepolis.scripts.persepolis:main'|" setup.py
  '';

  postInstall = ''
     mkdir -p $out/share/applications
     cp $src/xdg/com.github.persepolisdm.persepolis.desktop $out/share/applications
     wrapProgram $out/bin/persepolis --prefix PATH : "${lib.makeBinPath [aria libnotify ]}"
  '';

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    pulseaudio
    psutil
    pyqt5
    requests
    setproctitle
    sound-theme-freedesktop
    youtube-dl
  ];

  meta = with stdenv.lib; {
    description = "Persepolis Download Manager is a GUI for aria2.";
    homepage = https://persepolisdm.github.io/;
    license = licenses.gpl3;
    maintainers = [ maintainers.linarcx ];
  };
}
