{ stdenv, lib, fetchFromGitHub, python3Packages, gettext }:

with python3Packages;

buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    sha256 = "sha256-gcaamRxGn124LZ8rU+WzjRookU3akDO0ZyzI7/S6kFA=";
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
    pytestCheckHook
  ];

  # postPatch = ''
  #   sed -i 's/^requests.*$/requests>=2.2/' requirements.txt
  #   sed -i "s/'request.*'/'requests >= 2.2'/" setup.py
  # '';

  # network tests fails on darwin
  preCheck = ''
    rm tests/test_network.py tests/checker/test_http*.py tests/checker/test_content_allows_robots.py tests/checker/test_noproxy.py
  '';

  # test_timeit2 is flakey, and depends sleep being precise to the milisecond
  disabledTestPaths = [
    "tests/checker/{test_telnet,telnetserver}.py"
  ];

  disabledTests = [
    "TestLoginUrl"
    "test_timeit2"
  ];

  meta = {
    description = "Check websites for broken links";
    homepage = "https://linkcheck.github.io/linkchecker/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg tweber ];
  };
}
