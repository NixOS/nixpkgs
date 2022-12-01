{ stdenv, lib, fetchFromGitHub, python3Packages, gettext }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.2.0";
  format = "pyproject";

  disabled = pypkgs.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    hash = "sha256-wMiKS14fX5mkY1OwxQPFKm7i4WMFQKg3tdZZqD0g0Rw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with pypkgs; [
    argcomplete
    beautifulsoup4
    configargparse
    dnspython
    hatch-vcs
    hatchling
    pyopenssl
    requests
  ];

  checkInputs = with pypkgs; [
    parameterized
    pytest
  ];

  # test_timeit2 is flakey, and depends sleep being precise to the milisecond
  checkPhase = lib.optionalString stdenv.isDarwin ''
    # network tests fails on darwin
    rm tests/test_network.py tests/checker/test_http*.py tests/checker/test_content_allows_robots.py tests/checker/test_noproxy.py
  '' + ''
    pytest --ignore=tests/checker/{test_telnet,telnetserver}.py \
      -k 'not TestLoginUrl and not test_timeit2'
  '';

  meta = with lib; {
    description = "Check websites for broken links";
    homepage = "https://linkcheck.github.io/linkchecker/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg tweber ];
  };
}
