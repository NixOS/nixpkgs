{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, aria
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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    rev = version;
    sha256 = "1rh7q432ynbysapsd075nif975ync71icpb71x2mb4j8jx1vzs45";
  };

  # see: https://github.com/persepolisdm/persepolis/blob/3.2.0/setup.py#L130
  doCheck = false;

  preBuild=
  # Make setup automatic
  ''
    substituteInPlace setup.py --replace "answer = input(" "answer = 'y'#"
  '' +
  # Replace abandoned youtube-dl with maintained fork yt-dlp. Fixes https://github.com/persepolisdm/persepolis/issues/930,
  # can be removed if that issue is fixed and/or https://github.com/persepolisdm/persepolis/pull/936 is merged
  ''
    substituteInPlace setup.py ./persepolis/scripts/video_finder_addlink.py --replace \
        "import youtube_dl" "import yt_dlp as youtube_dl"
  '';

  patches = lib.optionals stdenv.isDarwin [
    # Upstream is abandonware, the last commit to master was on 2021-08-26.
    # If it is forked or picked up again, consider upstreaming these patches.
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
    "--prefix PATH : ${lib.makeBinPath [ aria ffmpeg libnotify ]}"
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
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iFreilicht ];
  };
}
