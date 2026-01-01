{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  click,
  pyyaml,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-external-toc";
  version = "1.0.1";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_external_toc";
    hash = "sha256-p9LGPMR+xohUZEOyi8TvRmEhgn7z3Hu1Cd41S61OouA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    pyyaml
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_external_toc" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Sphinx extension that allows the site-map to be defined in a single YAML file";
    mainProgram = "sphinx-etoc";
    homepage = "https://github.com/executablebooks/sphinx-external-toc";
    changelog = "https://github.com/executablebooks/sphinx-external-toc/raw/v${version}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
