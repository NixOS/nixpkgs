{ lib, stdenv
<<<<<<< HEAD
, coreutils
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, python3
, par2cmdline
, unzip
, unrar
, p7zip
<<<<<<< HEAD
, util-linux
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, nixosTests
}:

let
  pythonEnv = python3.withPackages(ps: with ps; [
<<<<<<< HEAD
    babelfish
    cffi
    chardet
    cheetah3
    cheroot
    cherrypy
    configobj
    cryptography
    feedparser
    guessit
    jaraco-classes
    jaraco-collections
    jaraco-context
    jaraco-functools
    jaraco-text
    more-itertools
    notify2
    orjson
    portend
    puremagic
    pycparser
    pysocks
    python-dateutil
    pytz
    rebulk
    sabctools
    sabyenc3
    sgmllib3k
    six
    tempora
    zc_lockfile
  ]);
  path = lib.makeBinPath [ coreutils par2cmdline unrar unzip p7zip util-linux ];
in stdenv.mkDerivation rec {
  version = "4.0.3";
=======
    chardet
    cheetah3
    cherrypy
    cryptography
    configobj
    feedparser
    sabyenc3
    puremagic
    guessit
    pysocks
  ]);
  path = lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "3.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "sabnzbd";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-6d/UGFuySgKvpqhGjzl007GS9yMgfgI3YwTxkxsCzew=";
=======
    sha256 = "sha256-1gGvdc6TJrkFIrN+TUL/7EejApgpgAQxnQbp8RMknHQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R * $out/
    mkdir $out/bin
    echo "${pythonEnv}/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
    chmod +x $out/bin/sabnzbd
    wrapProgram $out/bin/sabnzbd --set PATH ${path}

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.sabnzbd;
  };

  meta = with lib; {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = "https://sabnzbd.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ fridh jojosch adamcstephens ];
=======
    maintainers = with lib.maintainers; [ fridh jojosch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
