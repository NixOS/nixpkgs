{stdenv, fetchFromGitHub, python2, par2cmdline, unzip, unrar, p7zip, makeWrapper}:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cryptography cheetah yenc ]);
  path = stdenv.lib.makeBinPath [ par2cmdline unrar unzip p7zip ];
in stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "sabnzbd";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1rw6f455p0n8qigzkvnlr0d6rzkx2mpzhcp7m0j8fwqdbq831q8y";
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
