{ lib, stdenv
, fetchFromGitHub
, python3
, par2cmdline
, unzip
, unrar
, p7zip
, makeWrapper
}:

let
  pythonEnv = python3.withPackages(ps: with ps; [
    chardet
    cheetah3
    cherrypy
    cryptography
    configobj
    feedparser
    sabyenc3
  ]);
  path = lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "3.2.1";
  pname = "sabnzbd";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-y2uaXa2DPZHBLukAdwKTwXauaJHX5Uft35vsthzGwME=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    mkdir $out/bin
    echo "${pythonEnv}/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
    chmod +x $out/bin/sabnzbd
    wrapProgram $out/bin/sabnzbd --set PATH ${path}
  '';

  meta = with lib; {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = "https://sabnzbd.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
