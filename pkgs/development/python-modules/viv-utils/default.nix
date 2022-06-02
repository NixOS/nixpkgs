{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, funcy
, pefile
, vivisect
, intervaltree
, setuptools
}:
buildPythonPackage rec {
  pname = "viv-utils";
  version = "0.3.17";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "viv-utils";
    rev = "v${version}";
    sha256 = "wZWp6PMn1to/jP6lzlY/x0IhS/0w0Ys7AdklNQ+Vmyc=";
  };

  # argparse is provided by Python itself
  preBuild = ''
    sed '/"argparse",/d' -i setup.py
  '';

  propagatedBuildInputs = [
    funcy
    pefile
    vivisect
    intervaltree
    setuptools
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "viv_utils"
  ];

  meta = with lib; {
    description = "Utilities for working with vivisect";
    homepage = "https://github.com/williballenthin/viv-utils";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
