{ lib
, isPy27
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, urllib3
, beautifulsoup4
, dnspython
# required by tests
, pycodestyle
, pyflakes
, pylint
, flake8
, pyupgrade
}:

buildPythonPackage rec {
  pname = "snallygaster";
  version = "0.0.9";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "hannob";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gan5asgrxdgfi9lalhxzj3vs7nkazi8nqia36bpz1qb5fz7jrx3";
  };

  propagatedBuildInputs = [ urllib3 beautifulsoup4 dnspython ];

  checkInputs = [ pytestCheckHook pycodestyle pyflakes pylint flake8 pyupgrade ];

  meta = with lib; {
    homepage = "https://github.com/hannob/snallygaster";
    description = "Finds file leaks and other security problems on HTTP servers.";
    platforms = with platforms; linux ++ darwin;
    license = licenses.cc0;
    maintainers = with maintainers; [ veehaitch ];
  };
}
