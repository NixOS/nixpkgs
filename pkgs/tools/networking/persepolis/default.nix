{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, aria2
, ffmpeg
, libnotify
, pulseaudio
, psutil
, pyqt5
, requests
, setproctitle
, setuptools
, sound-theme-freedesktop
, wrapQtAppsHook
, yt-dlp
}:

buildPythonApplication rec {
  pname = "persepolis";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    rev = "refs/tags/${version}";
    sha256 = "sha256-2S6s/tWhI9RBFA26jkwxYTGeaok8S8zv/bY+Zr8TOak=";
  };

  # see: https://github.com/persepolisdm/persepolis/blob/3.2.0/setup.py#L130
  doCheck = false;

  # Make setup automatic
  preBuild= ''
    substituteInPlace setup.py --replace "answer = input(" "answer = 'y'#"
  '';

  patches = lib.optionals stdenv.isDarwin [
    # Upstream does currently not allow building from source on macOS. These patches can likely
    # be removed if https://github.com/persepolisdm/persepolis/issues/943 is fixed upstream
    ./0001-Allow-building-on-darwin.patch
    ./0002-Fix-startup-crash-on-darwin.patch
    ./0003-Search-PATH-for-aria2c-on-darwin.patch
    ./0004-Search-PATH-for-ffmpeg-on-darwin.patch
  ];

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
    "--prefix PATH : ${lib.makeBinPath [ aria2 ffmpeg libnotify ]}"
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
    yt-dlp
  ];

  meta = with lib; {
    description = "Persepolis Download Manager is a GUI for aria2";
    mainProgram = "persepolis";
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iFreilicht ];
  };
}
