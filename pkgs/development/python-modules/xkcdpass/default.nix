{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, installShellFiles
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.19.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-F7977Tb8iu/pRy6YhginJgK0N0G3CjPpHjomLTFf1F8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xkcdpass" ];

  postInstall = ''
    installManPage *.?
    install -Dm444 -t $out/share/doc/${pname} README*
  '';

  meta = with lib; {
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    homepage = "https://pypi.python.org/pypi/xkcdpass/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
