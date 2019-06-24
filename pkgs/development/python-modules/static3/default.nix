{ lib, fetchFromGitHub, buildPythonPackage, genshi, pytestCheckHook, pytest-cov, webtest }:

buildPythonPackage rec {
  pname = "static3";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rmohr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uFgv+57/UZs4KoOdkFxbvTEDQrJbb0iYJ5JoWWN4yFY=";
  };

  propagatedBuildInputs = [ genshi ];

  checkInputs = [ pytestCheckHook pytest-cov webtest ];

  meta = with lib; {
    description = "A really simple WSGI way to serve static (or mixed) content";
    homepage = "https://github.com/rmohr/static3";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.lgpl21Plus;
  };
}

