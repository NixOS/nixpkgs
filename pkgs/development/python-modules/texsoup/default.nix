{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "texsoup";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alvinwan";
    repo = "TexSoup";
    rev = "refs/tags/${version}";
    hash = "sha256-XKYJycYivtrszU46B3Bd4JLrvckBpQu9gKDMdr6MyZU=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "TexSoup" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace "--cov=TexSoup" ""
  '';

  meta = with lib; {
    description = "Fault-tolerant Python3 package for searching, navigating, and modifying LaTeX documents";
    homepage = "https://github.com/alvinwan/TexSoup";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
