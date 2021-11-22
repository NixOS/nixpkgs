{ stdenv, lib, fetchFromGitHub, python3Packages, gettext }:

with python3Packages;

buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    sha256 = "sha256-OOssHbX9nTCURpMKIy+95ZTvahuUAabLUhPnRp3xpN4=";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = [
    configargparse
    argcomplete
    beautifulsoup4
    pyopenssl
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
      rm tests/test_network.py tests/checker/test_http*.py tests/checker/test_content_allows_robots.py tests/checker/test_noproxy.py
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
