{ lib, buildPythonApplication, fetchFromGitHub, makeWrapper
, aria
, libnotify
, pulseaudio
, psutil
, pyqt5
, requests
, setproctitle
, setuptools
, sound-theme-freedesktop
, wrapQtAppsHook
, youtube-dl
}:

buildPythonApplication rec {
  pname = "persepolis";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    rev = version;
    sha256 = "1rh7q432ynbysapsd075nif975ync71icpb71x2mb4j8jx1vzs45";
  };

  # see: https://github.com/persepolisdm/persepolis/blob/3.2.0/setup.py#L130
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
  '';

  # prevent double wrapping
  dontWrapQtApps = true;
  nativeBuildInputs = [ wrapQtAppsHook ];

  # feed args to wrapPythonApp
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [aria libnotify ]}"
    "\${qtWrapperArgs[@]}"
  ];

  propagatedBuildInputs = [
    pulseaudio
    psutil
    pyqt5
    requests
    setproctitle
    setuptools
    sound-theme-freedesktop
    youtube-dl
  ];

  meta = with lib; {
    description = "Persepolis Download Manager is a GUI for aria2";
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
