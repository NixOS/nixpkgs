{ lib, buildPythonApplication, fetchFromGitHub, python, pyyaml, fonttools, fontforge }:

buildPythonApplication {
  pname = "scfbuild";
  version = "2.0.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "13rac1";
    repo = "scfbuild";
    rev = "6d84339512a892972185d894704efa67dd82e87a";
    sha256 = "0wkyzkhshlax9rvdmn441gv87n9abfr0qqmgs8bkg9kbcjb4bhad";
  };

  propagatedBuildInputs = [ pyyaml fonttools fontforge ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp -r scfbuild $out/${python.sitePackages}
    cp -r bin $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "SVGinOT color font builder";
    homepage = "https://github.com/13rac1/scfbuild";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "scfbuild";
  };
}
