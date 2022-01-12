{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, installShellFiles
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5a2e948746da6fe504e8404284f457d8e98da6df5047c6bb3f71b18882e9d2a";
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
