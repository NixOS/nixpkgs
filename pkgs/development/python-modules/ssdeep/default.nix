{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  pytestCheckHook,
  six,
  ssdeep,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ssdeep";
  version = "3.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-ssdeep";
    rev = "refs/tags/${version}";
    hash = "sha256-I5ci5BS+B3OE0xdLSahu3HCh99jjhnRHJFz830SvFpg=";
  };

  buildInputs = [ ssdeep ];

  propagatedBuildInputs = [
    cffi
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  pythonImportsCheck = [ "ssdeep" ];

  meta = with lib; {
    description = "Python wrapper for the ssdeep library";
    homepage = "https://github.com/DinoTools/python-ssdeep";
    changelog = "https://github.com/DinoTools/python-ssdeep/blob/${version}/CHANGELOG.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
