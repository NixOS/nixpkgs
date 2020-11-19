{ stdenv, lib, fetchFromGitHub, python3Packages, gettext }:

with python3Packages;

buildPythonApplication rec {
  pname = "linkchecker";
  version = "unstable-2020-08-15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "0086c28b3a419faa60562f2713346996062c03c2";
    sha256 = "0am5id8vqlqn1gb9jri0vjgiq5ffgrjq8yzdk1zc98gn2n0397wl";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = [
    ConfigArgParse
    argcomplete
    beautifulsoup4
    dnspython
    pyxdg
    requests
  ];

  checkInputs = [
    parameterized
    pytest
  ];

  postPatch = ''
    sed -i 's/^requests.*$/requests>=2.2/' requirements.txt
    sed -i "s/'request.*'/'requests >= 2.2'/" setup.py
  '';

  # test_timeit2 is flakey, and depends sleep being precise to the milisecond
  checkPhase = ''
    ${lib.optionalString stdenv.isDarwin ''
      # network tests fails on darwin
      rm tests/test_network.py
    ''}
      pytest --ignore=tests/checker/{test_telnet,telnetserver}.py \
        -k 'not TestLoginUrl and not test_timeit2'
  '';

  meta = {
    description = "Check websites for broken links";
    homepage = "https://linkcheck.github.io/linkchecker/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg tweber ];
  };
}
