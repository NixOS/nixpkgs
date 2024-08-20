{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  defusedxml,
  pytestCheckHook,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-jquery";
  version = "4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "jquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZQGQcVmhWREFa2KyaOKdTz5W2AS2ur7pFp8qZ2IkxSE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-tests-with-sphinx7.1.patch";
      url = "https://github.com/sphinx-contrib/jquery/commit/ac97ce5202b05ddb6bf4e5b77151a8964b6bf632.patch";
      hash = "sha256-dc9bhr/af3NmrIfoVabM1lNpXbGVsJoj7jq0E1BAtHw=";
    })
    (fetchpatch {
      # https://github.com/sphinx-contrib/jquery/pull/28
      name = "fix-tests-with-sphinx7.2-and-python312.patch";
      url = "https://github.com/sphinx-contrib/jquery/commit/3318a82854fccec528cd73e12ab2ab96d8e71064.patch";
      hash = "sha256-pNeKE50sm4b/KhNDAEQ3oJYGV4I8CVHnbR76z0obT3E=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "sphinxcontrib.jquery" ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
    sphinx
  ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Extension to include jQuery on newer Sphinx releases";
    longDescription = ''
      A sphinx extension that ensures that jQuery is installed for use
      in Sphinx themes or extensions
    '';
    homepage = "https://github.com/sphinx-contrib/jquery";
    changelog = "https://github.com/sphinx-contrib/jquery/blob/v${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ kaction ];
  };
}
