{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, installShellFiles
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.17.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ghsjs5bxl996pap910q9s21nywb26mfpjd92rbfywbnj8f2k2cy";
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
