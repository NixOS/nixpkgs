<<<<<<< HEAD
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
=======
{ lib, python3Packages, fetchFromGitHub, fetchurl, youtube-dl, git }:

let
  install_freedesktop = fetchurl {
    url = "https://github.com/thann/install_freedesktop/tarball/2673e8da4a67bee0ffc52a0ea381a541b4becdd4";
    sha256 = "0j8d5jdcyqbl5p6sc1ags86v3hr2sghmqqi99d1mvc064g90ckrv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
python3Packages.buildPythonApplication rec {
  pname = "play-with-mpv";
<<<<<<< HEAD
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

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Chrome extension and python server that allows you to play videos in webpages with MPV instead";
    homepage = "https://github.com/Thann/play-with-mpv";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
