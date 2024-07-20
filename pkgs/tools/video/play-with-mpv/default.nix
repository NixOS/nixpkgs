{ lib
, python3Packages
, fetchFromGitHub
, fetchurl
, youtube-dl
}:

let
  install-freedesktop = python3Packages.buildPythonPackage rec {
    pname = "install-freedesktop";
    version = "0.1.2-1-g2673e8d";
    format = "setuptools";

    src = fetchurl {
      name = "Thann-install_freedesktop-${version}.tar.gz";
      url = "https://github.com/thann/install_freedesktop/tarball/2673e8da4a67bee0ffc52a0ea381a541b4becdd4";
      hash = "sha256-O08G0iMGsF1DSyliXOHTIsOxDdJPBabNLXRhz5osDUk=";
    };

    # package has no tests
    doCheck = false;
  };
in
python3Packages.buildPythonApplication rec {
  pname = "play-with-mpv";
  version = "unstable-2021-04-02";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thann";
    repo = "play-with-mpv";
    rev = "07a9c1dd57d9e16538991b13fd3e2ed54d6e3a2d";
    hash = "sha256-ZtUFzgYGNa9+g2xDONW8B5bbsbXmyY3IeT1GQH0AVIw=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      '"https://github.com/thann/install_freedesktop/tarball/master#egg=install_freedesktop-0.2.0"' \
      '"file://${install-freedesktop}#egg=install_freedesktop-0.2.0"' \
      --replace 'version = get_version()' 'version = "0.1.0.post9"'
  '';

  nativeBuildInputs = with python3Packages; [
    install-freedesktop
    wheel
  ];

  propagatedBuildInputs = [
    youtube-dl
  ];

  # package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Chrome extension and python server that allows you to play videos in webpages with MPV instead";
    homepage = "https://github.com/Thann/play-with-mpv";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidsowa ];
    mainProgram = "play-with-mpv";
  };
}
