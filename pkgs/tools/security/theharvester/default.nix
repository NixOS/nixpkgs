{ stdenv, fetchFromGitHub, python2 }:

python2.pkgs.buildPythonApplication rec {
  name = "theharvester-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = "theHarvester";
    rev = version;
    sha256 = "0a8k6mdlprz4ahx8kmcadgd0fma1cbpc1ssb9la03y1rgkflq91s";
  };

  format = "other";

  propagatedBuildInputs = with python2.pkgs; [ requests ];

  postPatch = ''
    mv lib theharvester_lib
    for f in theHarvester.py theharvester_lib/*; do
      substituteInPlace $f \
        --replace 'from lib' 'from theharvester_lib'
    done
  '';

  installPhase = ''
    runHook preInstall

    install -vD theHarvester.py $out/bin/theharvester
    install -vd $out/${python2.sitePackages}/
    cp -R theharvester_lib discovery myparser.py $out/${python2.sitePackages}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "E-mails, subdomains and names Harvester";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
  };
}
