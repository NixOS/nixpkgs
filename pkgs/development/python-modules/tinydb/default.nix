{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, fetchpatch
, pytestCheckHook
, pycodestyle
, pyyaml
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "4.4.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3FbsnLU7G4VVhI5NYRqCEQgo51zDeAkEhH69H52zr/w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  patches = [
    # Switch to poetry-core, https://github.com/msiemens/tinydb/pull/391
    (fetchpatch {
      name = "switch-to-peotry-core.patch";
      url = "https://github.com/msiemens/tinydb/commit/5b547c18e7ce9f5925d5943dfa47d408435a0da5.patch";
      sha256 = "19ma9ib020b82sn1mcr7sfysqbj8h6nbb365bih1x1wn3ym8xlbc";
    })
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov-append --cov-report term --cov tinydb" ""
  '';

  checkInputs = [
    pytestCheckHook
    pycodestyle
    pyyaml
  ];

  pythonImportsCheck = [ "tinydb" ];

  meta = with lib; {
    description = "Lightweight document oriented database written in Python";
    homepage = "https://tinydb.readthedocs.org/";
    changelog = "https://tinydb.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
