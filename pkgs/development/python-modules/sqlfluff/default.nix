{ appdirs
, buildPythonPackage
, cached-property
, click
, colorama
, configparser
, diff_cover
, fetchFromGitHub
, isPy27
, lib
, oyaml
, pathspec
, pytest
, tblib
, typing-extensions
}:

buildPythonPackage rec {
  pname = "sqlfluff";
  version = "0.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "RW3+NpKZns3Jo1b3GfTymUE74pVoJi9f0zi4j4mUGiY=";
  };

  # ModuleNotFoundError: No module named 'dialects'
  doCheck = false;

  propagatedBuildInputs = [
    appdirs
    cached-property
    click
    colorama
    configparser
    diff_cover
    oyaml
    pathspec
    pytest
    tblib
    typing-extensions
  ];

  meta = with lib; {
    homepage = "https://www.sqlfluff.com/";
    description = "A SQL linter and auto-formatter for Humans";
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
}
