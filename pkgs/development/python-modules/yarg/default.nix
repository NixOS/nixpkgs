{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  nose,
  mock,
}:

buildPythonPackage rec {
  pname = "yarg";
  version = "0.1.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kura";
    repo = pname;
    rev = version;
    sha256 = "1isq02s404fp9whkm8w2kvb2ik1sz0r258iby0q532zw81lga0d0";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    nose
    mock
  ];
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "An easy to use PyPI client";
    homepage = "https://yarg.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
