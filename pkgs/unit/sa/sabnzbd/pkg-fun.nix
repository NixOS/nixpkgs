{ lib, stdenv
, fetchFromGitHub
, python3
, par2cmdline
, unzip
, unrar
, p7zip
, makeWrapper
, nixosTests
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
    puremagic
    guessit
    pysocks
  ]);
  path = lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "3.7.1";
  pname = "sabnzbd";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Zzqqh/3ijOTVVm5ksmsHY4LOL034VXHeZ7XsEg8cxY0=";
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
    maintainers = with lib.maintainers; [ fridh jojosch ];
  };
}
