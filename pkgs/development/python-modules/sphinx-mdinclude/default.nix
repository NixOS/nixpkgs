{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # dependencies
  docutils,
  mistune,
  pygments,
  sphinx,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-mdinclude";
  version = "0.6.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "sphinx_mdinclude";
    inherit version;
    hash = "sha256-RHRi6Cy4vmFASiIEIn+SB2nrkj0vV2COMyXzu4goa0w=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    docutils
    mistune
    pygments
    sphinx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/omnilib/sphinx-mdinclude";
    changelog = "https://github.com/omnilib/sphinx-mdinclude/blob/v${version}/CHANGELOG.md";
    description = "Sphinx extension for including or writing pages in Markdown format";
    longDescription = ''
      A simple Sphinx extension that enables including Markdown documents from within
      reStructuredText.
      It provides the .. mdinclude:: directive, and automatically converts the content of
      Markdown documents to reStructuredText format.

      sphinx-mdinclude is a fork of m2r and m2r2, focused only on providing a Sphinx extension.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [
      flokli
      JulianFP
    ];
  };
}
