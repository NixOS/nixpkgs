{ lib, python3, fetchPypi }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "pew";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uDEnKFJskBApXIghXJWhsXMf29GlaPco4GmTK9BUVhE=";
  };

  propagatedBuildInputs = [ virtualenv virtualenv-clone setuptools ];

  # no tests are packaged
  checkPhase = ''
    $out/bin/pew > /dev/null
  '';

  pythonImportsCheck = [ "pew" ];

  meta = with lib; {
    homepage = "https://github.com/berdario/pew";
    description = "Tools to manage multiple virtualenvs written in pure python";
    mainProgram = "pew";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ berdario ];
  };
}
