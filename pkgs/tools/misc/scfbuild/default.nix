{ lib, buildPythonApplication, fetchFromGitHub, python, pyyaml, fonttools, fontforge }:

buildPythonApplication {
  pname = "scfbuild";
  version = "1.0.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "13rac1";
    repo = "scfbuild";
    rev = "9acc7fc5fedbf48683d8932dd5bd7583bf922bae";
    sha256 = "1zlqsxkpg7zvmhdjgbqwwc9qgac2b8amzq8c5kwyh5cv95zcp6qn";
  };

  patches = [
    # Convert to Python 3
    # https://github.com/13rac1/scfbuild/pull/19
    ./python-3.patch
  ];

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
    homepage = https://github.com/13rac1/scfbuild;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
