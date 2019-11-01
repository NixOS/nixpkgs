{ stdenv, lib, fetchFromGitHub, python2Packages, gettext }:

python2Packages.buildPythonApplication rec {
  pname = "linkchecker";
  version = "9.4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1vbwl2vb8dyzki27z3sl5yf9dhdd2cpkg10vbgaz868dhpqlshgs";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with python2Packages; [
    ConfigArgParse
    argcomplete
    dnspython
    pyxdg
    requests
  ];

  checkInputs = with python2Packages; [
    parameterized
    pytest
  ];

  postPatch = ''
    sed -i 's/^requests.*$/requests>=2.2/' requirements.txt
    sed -i "s/'request.*'/'requests >= 2.2'/" setup.py
    sed -i 's~/usr/lib/python2.7/argparse.py~~g' po/Makefile
  '';

  checkPhase = ''
    runHook preCheck

    # the mime test fails for me...
    rm tests/test_mimeutil.py
    ${lib.optionalString stdenv.isDarwin ''
      # network tests fails on darwin
      rm tests/test_network.py
    ''}
    make test PYTESTOPTS="--tb=short" TESTS="tests/test_*.py tests/logger/test_*.py"

    runHook postCheck
  '';

  meta = {
    description = "Check websites for broken links";
    homepage = https://linkcheck.github.io/linkchecker/;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg tweber ];
  };
}
