{ lib, python3Packages, fetchFromGitHub, fetchurl, youtube-dl, git }:

let
  install_freedesktop = fetchurl {
    url = "https://github.com/thann/install_freedesktop/tarball/2673e8da4a67bee0ffc52a0ea381a541b4becdd4";
    sha256 = "0j8d5jdcyqbl5p6sc1ags86v3hr2sghmqqi99d1mvc064g90ckrv";
  };
in
python3Packages.buildPythonApplication rec {
  pname = "play-with-mpv";
  version = "unstable-2020-05-18";

  src = fetchFromGitHub {
      owner = "thann";
      repo = "play-with-mpv";
      rev = "656448e03fe9de9e8bd21959f2a3b47c4acb8c3e";
      sha256 = "1qma8b3lnkdhxdjsnrq7n9zgy53q62j4naaqqs07kjxbn72zb4p4";
  };

  nativeBuildInputs = [ git ];
  propagatedBuildInputs = [ youtube-dl ];

  postPatch = ''
    substituteInPlace setup.py --replace \
    '"https://github.com/thann/install_freedesktop/tarball/master#egg=install_freedesktop-0.2.0"' \
    '"file://${install_freedesktop}#egg=install_freedesktop-0.2.0"'
  '';

  meta = with lib; {
    description = "Chrome extension and python server that allows you to play videos in webpages with MPV instead";
    homepage = "https://github.com/Thann/play-with-mpv";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
