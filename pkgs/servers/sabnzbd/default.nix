{stdenv, fetchFromGitHub, python2, par2cmdline, unzip, unrar, p7zip, makeWrapper}:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cryptography cheetah yenc sabyenc ]);
  path = stdenv.lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "2.3.9";
  pname = "sabnzbd";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "06ln00rqz4xpsqhq0f495893xq1w5dfjawb8dgfyjjfds8627p16";
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
    homepage = "https://sabnzbd.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
