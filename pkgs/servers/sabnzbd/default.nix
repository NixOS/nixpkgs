{stdenv, fetchurl, python, par2cmdline, unzip, unrar, p7zip, makeWrapper}:

let
  pythonEnv = python.withPackages(ps: with ps; [ pyopenssl python.modules.sqlite3 cheetah]);
  path = stdenv.lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "sabnzbd-${version}";

  src = fetchurl {
    url = "https://github.com/sabnzbd/sabnzbd/archive/${version}.tar.gz";
    sha256 = "16srhknmjx5x2zsg1m0w9bipcv9b3b96bvb27fkf4dc2aswwcsc7";
  };

  buildInputs = [ pythonEnv makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    mkdir $out/bin
    echo "${pythonEnv}/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
    chmod +x $out/bin/sabnzbd
    wrapProgram $out/bin/sabnzbd --set PATH ${path}
  '';

  meta = with stdenv.lib; {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = http://sabnzbd.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
